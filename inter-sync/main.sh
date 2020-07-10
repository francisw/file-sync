#!/bin/bash
set -x

SRC=/mnt/app_data/cacheable
CACHE=/mnt/host/var/app_data

cd /mnt/app_data/.file-sync

[ -z $NODENAME ] && echo "NODENAME env required" && exit 1

# We don't want adverts from this node, or other nodes that this node is already contracted to
# Each advert is stored in adverts/{AdvertisingNode}/{AdvertisingPort}
# Each contract already taken by this node is stored in contracts/{ThisNode}/{ConnectedNode} and the file contains the connectedPort
IGNORE=(`ls contracts/${NODENAME}`)
IGNORE+=(${NODENAME})
function implode { local IFS="$1"; shift; echo "$*"; }
IGNORE_LIST=`implode '|' "${IGNORE[@]}"` 
# Get all adverts not from this node
ADVERTS=(`ls adverts/*/* | egrep -v "${IGNORE_LIST}"`)
if [ ${#ADVERTS[@]} -eq 0 ]; then
	>&2 echo "No Daemon node advert(s) found"
	exit 0
fi

# Remove the advert so nobody else takes it, and reformat from nodename/portnumber to nodename:portnumber
rm ${ADVERTS[0]}				# ${ADVERTS[0]} = "AdvertisedNode/AdvertisedPort"
IFS='/' read -ra ADVERT <<< "${ADVERTS[0]}" 	# $ADVERT = Array( 'adverts', AdvertisedNode, AdvertisedPort )
ADVERTISED_NODE=${ADVERT[1]}
ADVERTISED_PORT=${ADVERT[2]}

TARGET="${ADVERTISED_NODE}:${ADVERTISED_PORT}"
CONTRACT="contracts/${NODENAME}/${ADVERTISED_NODE}"  # Filename to announce what we are doing, so we have some record of who is synching with whom
echo ${ADVERTISED_PORT} > ${CONTRACT}  	# so we have some record of who is synching with whom
echo "${NODENAME} taking advertised ${TARGET}" >&2

unison 	\
	-root socket://${TARGET}/ \
	-root ${CACHE} \
	-killserver \
	-batch \
	-group -owner -times \
	-repeat watch \
	-prefer newer  

EXITCODE=$?
rm -f ${CONTRACT}
exit $EXITCODE
