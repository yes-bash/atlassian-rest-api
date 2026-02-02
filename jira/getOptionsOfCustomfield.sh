#!/bin/bash
# Author Benjamin Kotarlic (benjamin.kotarlic@gmail.com)

# usage: <this-script> <customfieldId> <contextId> "some option"

# get contexts of customfield
# https://<YOUR-SITE>.atlassian.net/rest/api/2/field/customfield_<customfieldId>/context

# get options of customfield
# https://developer.atlassian.com/cloud/jira/platform/rest/v2/api-group-issue-custom-field-options/#api-rest-api-2-field-fieldid-context-contextid-option-get
# https://<YOUR-SITE>.atlassian.net/rest/api/2/field/customfield_<customfieldId>/context/<contextId>/option?startAt=0 (?startAt=100 ...)

. ../.env

function getOptions () {
	curl -s --netrc-file ../${netrcFileJira} \
		--header 'Accept: application/json' \
		--header 'Content-Type: application/json' \
		--url "${url}/rest/api/3/field/customfield_${customfieldId}/context/${contextId}/option?startAt=${1}" 
}

customfieldId="${1}"
contextId="${2}"

startAt=0

while true
do
	result="$(getOptions ${startAt})"
	isLast="$(echo "$result" | jq -r '.isLast')"
	echo "${result}" |jq '.values[]'
	[[ "${isLast}" != "false" ]] && break
	startAt=$(( startAt + 100 ))
	sleep 1
done
