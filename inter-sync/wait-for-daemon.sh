#!/bin/bash

# Nota Bene
#
# This process waits for a daemon to advertise FROM ANOTHER NODE
# It is NOT waiting for the file-sync-daemons that are started on this node
#
# It waits TIMER seconds, LOOP times before giving up. Setting either of these too large
# will cause nodes to double up on connections. Default values of 5 seconds overall then give up

SRC=/mnt/app_data/cacheable/.file-sync
CACHE=/mnt/host/var/app_data/.file-sync

TIMER=1
LOOP=5
# Are there any advertisers there (other than our node)
ADVERTS=(`ls ${SRC}/*/* | grep -v $NODENAME`)
until [ ${#ADVERTS[@]} -gt 0 ]; do
	>&2 echo "Waiting for daemon adverts - sleeping"
	sleep ${TIMER}
	if [ ${LOOP} -gt 5 ]; then
		>&2 echo "Timeout - No Daemon advert(s) found"
		exit 0
	fi
	LOOP=$((LOOP+1))
	ADVERTS=(`ls ${SRC}/*/* | grep -v $NODENAME`)
done

>&2 echo "Daemon advert(s) found - proceeding with ${@}"

exec ${@}

