#!/bin/bash

. ../.env

pageId="${1}"

# save old restrictions
curl -s --netrc-file ${netrcFileConfluence} -s --header 'Accept: */*' --header 'Content-Type: application/json' \
        -b "confluence.asSuperAdmin=true" \
        --url "${url}/wiki/rest/api/content/${pageId}/restriction" > ${pageId}.restictions


# overwrite permissions with our admin user
curl -s --netrc-file ${netrcFileConfluence} -s --header 'Accept: */*' --header 'Content-Type: application/json' \
        --url "${url}/cgraphql?q=DirectRestrictionsMutation" \
        -o /dev/null \
        -X POST \
        --data '[{"operationName":"DirectRestrictionsMutation","variables":{"pageId":"'${pageId}'","restrictions":{"read":{"group":[],"user":[{"id":"'${confluenceUserId}'"}]},"update":{"group":[],"user":[{"id":"'${confluenceUserId}'"}]}}},"query":"mutation DirectRestrictionsMutation($pageId: ID\u0021, $restrictions: PageRestrictionsInput) @asSuperAdmin {\n  updatePage(input: {pageId: $pageId, restrictions: $restrictions}) {\n    page {\n      id\n      __typename\n    }\n    __typename\n  }\n}\n"}]'
