#!/bin/bash

SRC=/mnt/app_data/cacheable
CACHE=/mnt/host/var/app_data
[ ! -d ${SRC}/.file-sync ] && 
	mkdir -p ${SRC}/.file-sync/adverts ${SRC}/.file-sync/contracts && 
	chmod -R a+rwx ${SRC}/.file-sync
cd ${SRC}/.file-sync

#
# Create and Pre-fill cache by copying (slowly) to a temp location and then quickly switching the folder /mnt/host/var/app_data
# ** there could be another copy of this running (in error) and we don't want to trigger that to empty cacheable **
#   Leaves whatever was previously in /mnt/host/var/app_data as /mnt/host/var/app_data-

[ -d ${CACHE}+ ] && rm -rf ${CACHE}+
cp -rp ${SRC} ${CACHE}+

[ -d ${CACHE}- ] && rm -rf ${CACHE}-
[ -d ${CACHE} ] && mv ${CACHE} ${CACHE}-
mv ${CACHE}+ ${CACHE}

# Sync this nodes SRC and CACHE
exec unison 	\
	-root ${SRC} \
	-root ${CACHE} \
	-repeat watch \
	-prefer newer  
