#!/bin/bash
# Author Benjamin Kotarlic (benjamin.kotarlic@gmail.com)
# 
# this is for quick testing only
#
# usage: <this_script> <GET|POST|UPDATE|PUT> "/wiki/some/path/to/rest/api?parameter=value" "(optional) --data='foo=bar'"
#

. ../.env

curl -s --netrc-file ../${netrcFileConfluence} \
	-X ${1} \
	--header 'Accept: application/json' \
	--header 'Content-Type: application/json' \
	--url "${url}${2}" ${3}
