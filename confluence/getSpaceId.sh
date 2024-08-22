#!/bin/bash
# Author Benjamin Kotarlic (benjamin.kotarlic@gmail.com)

. ../.env

curl -s --netrc-file ../${netrcFileConfluence} \
	--header 'Accept: application/json' \
	--header 'Content-Type: application/json' \
	--url "${url}/wiki/api/v2/spaces?keys=${1}" |jq '.results[0].id' -r

