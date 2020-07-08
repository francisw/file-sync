#!/bin/bash

SRC=/mnt/app_data/cacheable/.file-sync
CACHE=/mnt/host/var/app_data/.file-sync

[ -z $NODENAME ] && echo "NODENAME env required" && exit 1
[ -z $ADVERTISE_PORT ] && echo "ADVERTISE_PORT env required" && exit 1

# Setup folders
# ./adverts/${NODENAME}
# ./contracts/${NODENAME}
[ ! -d ${SRC}/adverts/${NODENAME} -o ! -d ${SRC}/contracts/${NODENAME} ] && \
	mkdir -p ${SRC}/adverts/${NODENAME} ${SRC}/contracts/${NODENAME} && \
	chmod a+rwx ${SRC}/*/${NODENAME} 

PROBE=$NODENAME.${ADVERTISE_PORT}
echo > ${SRC}/${PROBE}
until [ -f ${CACHE}/${PROBE} ]; do
	>&2 echo "Waiting for file-sync - sleeping"
	sleep 1
done
rm -f ${SRC}/${PROBE}
>&2 echo "File-sync verified - proceeding with ${@}"

exec ${@}
