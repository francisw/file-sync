#!/bin/bash

SRC=/mnt/app_data/cacheable/.file-sync
CACHE=/mnt/host/var/app_data/.file-sync

# Are there any advertisers there (other than our node)
ADVERTS=(`ls ${SRC}/*/* | grep -v $NODENAME`)
until [ ${#ADVERTS[@]} -gt 0 ]; do
	>&2 echo "Waiting for daemon adverts - sleeping"
	sleep 1
	ADVERTS=(`ls ${SRC}/*/* | grep -v $NODENAME`)
done

>&2 echo "Daemon advert(s) found - proceeding with ${@}"

exec ${@}

