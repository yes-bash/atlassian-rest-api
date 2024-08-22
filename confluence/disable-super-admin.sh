#!/bin/bash
# Author Benjamin Kotarlic (benjamin.kotarlic@gmail.com)

. ../.env

curl -s --netrc-file ../${netrcFileConfluence} -s --header 'Accept: */*' --header 'Content-Type: application/json' \
        -o /dev/null \
        --url "${url}/cgraphql?q=EnableSuperAdmin" \
        -X POST \
        -H 'x-apollo-operation-name: DisableSuperAdmin' \
        --data '[{"operationName":"DisableSuperAdmin","variables":{},"query":"mutation DisableSuperAdmin @asSuperAdmin { disableSuperAdmin { user { id confluence { roles { isSuperAdmin }}}}}"}]' |jq 
