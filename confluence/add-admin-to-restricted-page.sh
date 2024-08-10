#!/bin/bash
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
	# save old restrictions
	curl -s --netrc-file ../${netrcFileConfluence} -s --header 'Accept: */*' --header 'Content-Type: application/json' \
	        -b "confluence.asSuperAdmin=true" \
	        --url "${url}/wiki/rest/api/content/${pageId}/restriction" > ${pageId}.restictions
	
	# overwrite permissions with our admin user
	curl -s --netrc-file ../${netrcFileConfluence} -s --header 'Accept: */*' --header 'Content-Type: application/json' \
	        --url "${url}/cgraphql?q=DirectRestrictionsMutation" \
	        -o /dev/null \
	        -X POST \
	        --data '[{"operationName":"DirectRestrictionsMutation","variables":{"pageId":"'${pageId}'","restrictions":{"read":{"group":[],"user":[{"id":"'${confluenceUserId}'"}]},"update":{"group":[],"user":[{"id":"'${confluenceUserId}'"}]}}},"query":"mutation DirectRestrictionsMutation($pageId: ID\u0021, $restrictions: PageRestrictionsInput) @asSuperAdmin {\n  updatePage(input: {pageId: $pageId, restrictions: $restrictions}) {\n    page {\n      id\n      __typename\n    }\n    __typename\n  }\n}\n"}]'
	
	# add old restrictions
	curl -s --netrc-file ../${netrcFileConfluence} -s --header 'Accept: */*' --header 'Content-Type: application/json' \
	        -o /dev/null \
	        -X POST \
	        --url "${url}/wiki/rest/api/content/${pageId}/restriction"  \
	        --data-binary "@${pageId}.restictions" |jq
	
	#rm -f ${pageId}.restictions
done

# disable superadmin
bash disable-super-admin.sh
