#!/bin/bash

SHARE=/mnt/app_data/cacheable/.file-sync

[ -z ${NODENAME} ] && echo "NODENAME env required" && exit 1
[ -z ${ADVERTISE_PORT} ] && echo "ADVERTISE_PORT env required" && exit 1

[ ! -d ${SHARE}/adverts/${NODENAME} ] && mkdir -p ${SHARE}/adverts/${NODENAME}
[ ! -d ${SHARE}/contracts/${NODENAME} ] && mkdir -p ${SHARE}/contracts/${NODENAME}
touch ${SHARE}/adverts/${NODENAME}/${ADVERTISE_PORT}

exec unison -socket 9999
