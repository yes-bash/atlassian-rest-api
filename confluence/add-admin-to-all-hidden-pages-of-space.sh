#!/bin/bash
# Author Benjamin Kotarlic (benjamin.kotarlic@gmail.com)

. ../.env

spaceKey="${1}"

bash getHiddenPagesOfSpace.sh "${spaceKey}" > ${tmp}/${spaceKey}.hidden

echo "hidden pages:"
cat ${tmp}/${spaceKey}.hidden

bash add-admin-to-restricted-page.sh -f ${tmp}/${spaceKey}.hidden

rm -f ${tmp}/${spaceKey}.hidden
