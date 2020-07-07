FROM swarm-manager:5000/brcms/unison

COPY ./*.sh /opt/bin/
WORKDIR /opt/bin

# Healcheck writes a file to cache and then removes the same file 
# from shared storagte 1s later
HEALTHCHECK --interval=30s \
	--retries=3 \
	--timeout=1s \
	CMD /bin/true
#	CMD F=.file-sync/sync-check.$RANDOM && \
#		touch /mnt/host/var/app_data/${F} && \
#		sleep 1 && \
#		[ -f /mnt/app_data/cacheable/${F} ]  # AND rm -f /mnt/app_data/cacheable/${F}

CMD ["/opt/bin/main.sh"]
