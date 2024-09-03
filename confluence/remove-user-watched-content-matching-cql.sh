#!/bin/bash

# usage: <this-script> "<userId>" "<optional: cql>"
#
# examples
#
# removes a user with userId 12345678901234567890 from all pages as a watcher
# bash <this-script> "12345678901234567890"
#
# removes a user as a watcher from all watched content of space LOREM
# bash <this-script> "12345678901234567890" "%20and%20space%20=%20LOREM"
#

# https://developer.atlassian.com/cloud/confluence/rest/v1/api-group-content-watches/#api-wiki-rest-api-user-watch-content-contentid-delete
# https://developer.atlassian.com/cloud/confluence/rest/v1/api-group-search/#api-wiki-rest-api-search-get


userId="${1}"
cql="watcher='${userId}'${2}"
out="/tmp/$(basename $0).tmp"

# get pageIds of watched content
bash api.sh GET "/wiki/rest/api/search?limit=1000&cql=${cql}" | jq '.results[] | .content.id' -r >${out}

count="$(wc -l ${out}|awk '{print $1}')"
echo "found pages: ${count}"

[[ "${count}" -le 0 ]] && exit 0

cat ${out} |while read pageId
do 
	echo "removing user ${userId} from page ${pageId}"
	bash api.sh DELETE "/wiki/rest/api/user/watch/content/${pageId}?accountId=${userId}"
done

[[ -f ${out} ]] && rm -f ${out}
