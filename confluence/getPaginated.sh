#!/bin/bash
# Author Benjamin Kotarlic (benjamin.kotarlic@gmail.com)

. ../.env


function getPaginated () {
	unset data
	data="$(curl --netrc-file ../${netrcFileConfluence} -s --header 'Accept: application/json' --header 'Content-Type: application/json' -b "confluence.asSuperAdmin=true" --url "${1}")"
	next="$(echo "${data}" |jq -r '._links.next')"
	echo "${data}" | jq '.results'
	if [ ${#next} -gt 5 ]; then
	        getPaginated "${url}${next}"
	fi
}

getPaginated "${1}"
