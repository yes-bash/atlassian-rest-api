#!/bin/bash
# Author Benjamin Kotarlic (benjamin.kotarlic@gmail.com)

# usage: 
# 
# if you want to change the restrictions of a single page
#         add-admin-to-restricted-page.sh <confluencePageId>
#
# if you want to change all pageIds listed in a file
#         add-admin-to-restricted-page.sh -f <someFile>

. ../.env

while getopts ":f:" opt; do
  case ${opt} in
    f)
        file="${OPTARG}"
        ;;
    :)
        echo "Option -${OPTARG} requires an argument."
        exit 1
        ;;
    ?)
        echo "Invalid option: -${OPTARG}."
        exit 1
        ;;
  esac
done

if [ -f "${file}" ]; then
        input="cat ${file}"
else
        input="echo ${1}"
fi

# enable superadmin
bash enable-super-admin.sh

${input} |while read pageId
do
	unset userRead groupRead userUpdate groupUpdate

	# get old restrictions
	curl -s --netrc-file ../${netrcFileConfluence} -s --header 'Accept: */*' --header 'Content-Type: application/json' \
	        -b "confluence.asSuperAdmin=true" \
	        --url "${url}/wiki/rest/api/content/${pageId}/restriction" > ${tmp}/${pageId}.restictions

	# get user read restrictions
	while read line
	do
		userRead+="{\"id\":\"${line}\"},"
	done < <( jq '.results[] | select (.operation == "read") |.restrictions.user.results[].accountId' ${tmp}/${pageId}.restictions -r; echo ${confluenceUserId} )

	# get group read restrictions
	while read line
	do
		id="$(echo "${line}" |jq '.id' -r)"
		name="$(echo "${line}" |jq '.name' -r)"
		groupRead+="{\"id\":\"${id}\",\"name\":\"${name}\"},"
	done < <( jq '.results[] | select (.operation == "read") |.restrictions.group.results[] | { id: .id, name: .name }' ${tmp}/${pageId}.restictions -c )

	# get user update restrictions
	while read line
	do
		userUpdate+="{\"id\":\"${line}\"},"
	done < <( jq '.results[] | select (.operation == "update") |.restrictions.user.results[].accountId' ${tmp}/${pageId}.restictions -r; echo ${confluenceUserId} )

	# get group update restrictions
	while read line
	do
		id="$(echo "${line}" |jq '.id' -r)"
		name="$(echo "${line}" |jq '.name' -r)"
		groupUpdate+="{\"id\":\"${id}\",\"name\":\"${name}\"},"
	done < <( jq '.results[] | select (.operation == "update") |.restrictions.group.results[] | { id: .id, name: .name }' ${tmp}/${pageId}.restictions -c )
	
	# overwrite permissions with our admin user
	curl -v -s --netrc-file ../${netrcFileConfluence} -s --header 'Accept: */*' --header 'Content-Type: application/json' \
	        --url "${url}/cgraphql?q=DirectRestrictionsMutation" \
	        -X POST \
	        -o /dev/null \
	        --data '[{"operationName":"DirectRestrictionsMutation","variables":{"pageId":"'${pageId}'","restrictions":{"read":{"group":['${groupRead%?}'],"user":['${userRead%?}']},"update":{"group":['${groupUpdate%?}'],"user":['${userUpdate%?}']}}},"query":"mutation DirectRestrictionsMutation($pageId: ID\u0021, $restrictions: PageRestrictionsInput) @asSuperAdmin {\n  updatePage(input: {pageId: $pageId, restrictions: $restrictions}) {\n    page {\n      id\n      __typename\n    }\n    __typename\n  }\n}\n"}]'
	
	rm -f ${tmp}/${pageId}.restictions
done

# disable superadmin
bash disable-super-admin.sh
