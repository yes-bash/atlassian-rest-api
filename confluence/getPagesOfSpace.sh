#!/bin/bash

. ../.env

spaceId="$(bash getSpaceId.sh ${1})"

bash getPaginated.sh "${url}/wiki/api/v2/pages?space-id=${spaceId}&body-format=storage&status=current&limit=250"


