#!/bin/bash

SHARE=/mnt/app_data/cacheable/.file-sync

[ -z ${NODENAME} ] && echo "NODENAME env required" && exit 1
[ -z ${ADVERTISE_PORT} ] && echo "ADVERTISE_PORT env required" && exit 1
[ ! -d ${SHARE}/${NODENAME} ] && mkdir ${SHARE}/${NODENAME}
echo > ${SHARE}/${NODENAME}/${ADVERTISE_PORT}

exec unison -socket 9999
