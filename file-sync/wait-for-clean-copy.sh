#!/bin/bash
set -x

FILESYNC=/mnt/app_data/.file-sync
SRC=/mnt/app_data/cacheable
CACHE=/mnt/host/var/app_data

#
# Create and Pre-fill cache by copying (slowly) to a temp location and then quickly switching the folder /mnt/host/var/app_data
# ** there could be another copy of this running (in error) and we don't want to trigger that to empty cacheable **
#   Leaves whatever was previously in /mnt/host/var/app_data as /mnt/host/var/app_data-

[ -d ${CACHE}+ ] && rm -rf ${CACHE}+
cp -rp ${SRC} ${CACHE}+
chmod a+rwx ${CACHE}+

[ -d ${CACHE}- ] && rm -rf ${CACHE}-
[ -d ${CACHE} ] && mv ${CACHE} ${CACHE}-
mv ${CACHE}+ ${CACHE}

[ -z $NODENAME ] && echo "NODENAME env required" && exit 1
# Setup folders, empty adverts/contracts for this node
# ./adverts/${NODENAME}
# ./contracts/${NODENAME}
for NODE in ${FILESYNC}/adverts/${NODENAME} ${FILESYNC}/contracts/${NODENAME}; do
	[ ! -d ${NODE} ] && mkdir -p ${NODE} && chmod a+rwx ${NODE}
	rm -rf ${NODE}/*
done

>&2 echo "Clean ${CACHE} copied - proceeding with ${@}"

su-exec nginx ${@}
