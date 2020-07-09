#!/bin/bash
set -x

SRC=/mnt/app_data/cacheable
CACHE=/mnt/host/var/app_data

# Sync this nodes SRC and CACHE
exec unison 	\
	-root ${SRC} \
	-root ${CACHE} \
	-batch \
	-group -owner -times \
	-repeat watch \
	-prefer newer  
