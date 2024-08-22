#!/bin/bash
# Author Benjamin Kotarlic (benjamin.kotarlic@gmail.com)

. ../.env

bash getPagesOfSpace.sh "${1}" | jq -r '.[].id' > ${tmp}/getHiddenPagesOfSpace.1
bash enable-super-admin.sh &>/dev/null
bash getPagesOfSpace.sh "${1}" | jq -r '.[].id' > ${tmp}/getHiddenPagesOfSpace.2
bash disable-super-admin.sh &>/dev/null
diff ${tmp}/getHiddenPagesOfSpace.1 ${tmp}/getHiddenPagesOfSpace.2 |grep "^>" |awk {'print $2'}
rm -f ${tmp}/getHiddenPagesOfSpace.*


