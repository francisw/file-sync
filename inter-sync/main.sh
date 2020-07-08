#!/bin/bash

SRC=/mnt/app_data/cacheable
CACHE=/mnt/host/var/app_data

cd /mnt/app_data/cacheable/.file-sync

# Spec is {node}/{port}
# Cleanup old
# find * -type f -mmin +5 -exec rm -f {} +

[ -z $NODENAME ] && echo "NODENAME env required" && exit 1

# Get all adverts not from this node
ADVERTS=(`ls */* | grep -v $NODENAME`)
if [ ${#ADVERTS[@]} -eq 0 ]; then
	>&2 echo "No Daemon node advert(s) found"
	exit 0
fi

# Remove the advert and reformat from nodname/portnumber to nodename:portnumber
rm ${ADVERTS[0]}
TARGET=${ADVERTS[0]//[\/]/:}
echo ${NODENAME} >> .${TARGET}  # so we have some record of who is synching with whom
echo "${NODENAME} taking advertised ${TARGET}" >&2

echo unison 	\
	-root socket://${TARGET}/ \
	-root ${CACHE} \
	-killserver \
	-repeat watch \
	-prefer newer  
unison 	\
	-root socket://${TARGET}/ \
	-root ${CACHE} \
	-killserver \
	-repeat watch \
	-prefer newer  

EXITCODE=$?
rm -f .${TARGET}
exit $EXITCODE
