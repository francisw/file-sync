#!/bin/bash
set -x
FILESYNC=/mnt/app_data/.file-sync

[ -z ${NODENAME} ] && echo "NODENAME env required" && exit 1
[ -z ${ADVERTISE_PORT} ] && echo "ADVERTISE_PORT env required" && exit 1

touch ${FILESYNC}/adverts/${NODENAME}/${ADVERTISE_PORT}

exec unison -socket 9999
