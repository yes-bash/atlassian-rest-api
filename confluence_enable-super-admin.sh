#!/bin/bash

. .env

curl -s --netrc-file ${netrcFileConfluence} -s --header 'Accept: */*' --header 'Content-Type: application/json' \
        --url "${url}/cgraphql?q=EnableSuperAdmin" \
        -X POST \
        -H 'x-apollo-operation-name: EnableSuperAdmin' \
        -o /dev/null \
        --data '[{"operationName":"EnableSuperAdmin","variables":{},"query":"mutation EnableSuperAdmin { enableSuperAdmin { user { id confluence { roles { isSuperAdmin }}}}}"}]' 
