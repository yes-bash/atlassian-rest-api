#!/bin/bash
# Author Benjamin Kotarlic (benjamin.kotarlic@gmail.com)

# this script will change the owner of all filters with old-owner-id to new-owner-id
#
# usage: <this_script> <old-owner-id> <new-owner-id>
#

. ../.env


function getUser () {
	curl -s --netrc-file ../${netrcFileJira} \
	--header 'Accept: application/json' \
	--header 'Content-Type: application/json' \
	--url "${url}/rest/api/2/user?accountId=${1}" 2>/dev/null |jq '{ displayName: .displayName, accountId: .accountId}' 
}

function getFilters () {
	curl -s --netrc-file ../${netrcFileJira} \
	--header 'Accept: application/json' \
	--header 'Content-Type: application/json' \
	--url "${url}/rest/api/2/filter/search?accountId=${oldOwner}&overrideSharePermissions=true" 2>/dev/null |jq '.values[] | { id: .id, name: .name }' -c 2>/dev/null
}

function changeFilterOwner () {
	local filterId="${1}"
	local newOwner="${2}"
	curl -s --netrc-file ../${netrcFileJira} \
	-X PUT \
	--url "${url}/rest/api/3/filter/${filterId}/owner" \
	--header 'X-ExperimentalApi: opt-in' \
	--header 'Accept: application/json' \
	--header 'Content-Type: application/json' \
	--data "{\"accountId\": \"${newOwner}\"}"
}


oldOwner="${1}"
newOwner="${2}"

oldDisplayName="$(getUser "${oldOwner}"|jq '.displayName' -r)"
newDisplayName="$(getUser "${newOwner}"|jq '.displayName' -r)"

filters="$(getFilters)"
filterCount="$(echo "${filters}" |wc -l |awk {'print $1'})"

echo "User \"${oldDisplayName}\" has ${filterCount} filter(s)."
echo "${filters}" |jq '.name'
echo
echo "Do you want to transfer these filters to new owner \"${newDisplayName}\" (${newOwner})"
read

echo "${filters}" | while read -r line
do
	filterId="$(echo "${line}" |jq '.id' -r)"
	echo "filterId: ${filterId}"
	changeFilterOwner "${filterId}" "${newOwner}"
done



