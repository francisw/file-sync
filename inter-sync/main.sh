#!/bin/bash

SRC=/mnt/app_data/cacheable
CACHE=/mnt/host/var/app_data

cd /mnt/app_data/cacheable/.file-sync

# Advert spec is {node}/{port}
# Idea for a Cleanup old if healtcheck refreshes the advert_taken files
# find * -type f -mmin +5 -exec rm -f {} +

[ -z $NODENAME ] && echo "NODENAME env required" && exit 1

# We don't want adverts from this node, or other nodes that this node is already contracted to
# Each advert is stored in adverts/{AdvertisingNode}/{AdvertisingPort}
# Each contract already taken by this node is stored in contracts/{ThisNode}/{ConnectedNode} and the file contains the connectedPort
IGNORE=(`ls contracts/${NODENAME}`)
IGNORE+=(${NODENAME})
IGNORE_LIST=${IGNORE[*]//\s/\|}
# Get all adverts not from this node
ADVERTS=(`ls */* | grep -v ${IGNORE_LIST}`)
if [ ${#ADVERTS[@]} -eq 0 ]; then
	>&2 echo "No Daemon node advert(s) found"
	exit 0
fi

# Remove the advert so nobody else takes it, and reformat from nodename/portnumber to nodename:portnumber
rm ${ADVERTS[0]}				# ${ADVERTS[0]} = "AdvertisedNode/AdvertisedPort"
IFS='/' read -ra ADVERT <<< "${ADVERTS[0]}" 	# $ADVERT = Array( AdvertisedNode, AdvertisedPort )
ADVERTISED_NODE=${ADVERT[0]}
ADVERTISED_PORT=${ADVERT[1]}

TARGET="${ADVERTISED_NODE}:${ADVERTISED_PORT}"
CONTRACT="contracts/${NODENAME}/${ADVERTISED_NODE}"  # Filename to announce what we are doing, so we have some record of who is synching with whom
echo ${ADVERTISED_PORT} > ${CONTRACT}  	# so we have some record of who is synching with whom
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
rm -f ${CONTRACT}
exit $EXITCODE
