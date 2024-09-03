#!/bin/bash
# Author Benjamin Kotarlic (benjamin.kotarlic@gmail.com)

# usage: <this-script> <customfieldId> <contextId> "some option"

# get contexts of customfield
# https://<YOUR-SITE>.atlassian.net/rest/api/2/field/customfield_<customfieldId>/context

# get options of customfield
# https://developer.atlassian.com/cloud/jira/platform/rest/v2/api-group-issue-custom-field-options/#api-rest-api-2-field-fieldid-context-contextid-option-get
# https://<YOUR-SITE>.atlassian.net/rest/api/2/field/customfield_<customfieldId>/context/<contextId>/option?startAt=0 (?startAt=100 ...)

. ../.env

function addOption () {
	curl -s --netrc-file ../${netrcFileJira} \
		-X POST \
		--header 'Accept: application/json' \
		--header 'Content-Type: application/json' \
		--url "${url}/rest/api/3/field/customfield_${customfieldId}/context/${contextId}/option" \
		--data "{ \"options\": [{\"disabled\": false, \"value\": \"${option}\" }]}"
}

customfieldId="${1}"
contextId="${2}"
option="${3}"

addOption
