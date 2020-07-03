#!/bin/bash
SRC=/mnt/app_data/cacheable
CACHE=/mnt/host/var/app_data
#
# Create and Pre-fill cache by copying (slowly) to a temp location and then quickly switching the /mnt/host/var/app_data
# ** there ciould be another copy of this running (in error) and we don't want to trigger that to empty cacheable **
sudo [ -d ${CACHE}+ ] && sudo rm -rf ${CACHE}+
sudo cp -rp ${SRC} ${CACHE}+

sudo [ -d ${CACHE}- ] && sudo rm -rf ${CACHE}-
sudo [ -d ${CACHE} ] && sudo mv ${CACHE}-
sudo mv ${CACHE}+ ${CACHE}
sudo [ -d ${CACHE}- ] && sudo rm -rf ${CACHE}-

# Provide a port for testing (inter-node sync TBD)
unison  -socket 9001  &
 
# Sync this nodes SRC and CACHE
unison 	-root ${SRC} \
	-root ${CACHE} \
	-repeat watch \
	-prefer newer  
