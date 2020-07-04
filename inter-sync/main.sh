#!/bin/bash

SRC=/mnt/app_data/cacheable
CACHE=/mnt/host/var/app_data
[ ! -d ${SRC}/.file-sync ] && mkdir ${SRC}/.file-sync && chmod a+rwx ${SRC}/.file-sync
cd ${SRC}/.file-sync

#
# Create and Pre-fill cache by copying (slowly) to a temp location and then quickly switching the /mnt/host/var/app_data
# ** there ciould be another copy of this running (in error) and we don't want to trigger that to empty cacheable **
[ -d ${CACHE}+ ] && rm -rf ${CACHE}+
cp -rp ${SRC} ${CACHE}+

[ -d ${CACHE}- ] && rm -rf ${CACHE}-
[ -d ${CACHE} ] && mv ${CACHE} ${CACHE}-
mv ${CACHE}+ ${CACHE}
[ -d ${CACHE}- ] && rm -rf ${CACHE}-

# Sync this nodes SRC and CACHE
unison 	-root ${SRC} \
	-root ${CACHE} \
	-repeat watch \
	-prefer newer  
