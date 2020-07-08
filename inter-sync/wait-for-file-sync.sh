#!/bin/bash

SRC=/mnt/app_data/cacheable/.file-sync
CACHE=/mnt/host/var/app_data/.file-sync

[ -z $NODENAME ] && echo "NODENAME env required" && exit 1
[ ! -d ${SRC}/${NODENAME} ] && mkdir ${SRC}/${NODENAME}

RANDOM=$(date +%N)
PROBE=$NODENAME.${RANDOM}

echo > ${SRC}/${PROBE}
until [ -f ${CACHE}/${PROBE} ]; do
	>&2 echo "Waiting for file-sync - sleeping"
	sleep 1
done
rm -f ${SRC}/${PROBE}
>&2 echo "File-sync verified - proceeding with ${@}"

exec ${@}
