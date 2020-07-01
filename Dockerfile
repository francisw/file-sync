FROM alpine:3.6

ARG UNISON_VERSION=2.51.2

# Install in one run so that build tools won't remain in any docker layers
# Install build tools
RUN apk add --update build-base curl bash ocaml && \
    # Download & Install Unison
    curl -L https://github.com/bcpierce00/unison/archive/v$UNISON_VERSION.tar.gz | tar zxv -C /tmp && \
    cd /tmp/unison-${UNISON_VERSION} && \
    sed -i -e 's/GLIBC_SUPPORT_INOTIFY 0/GLIBC_SUPPORT_INOTIFY 1/' src/fsmonitor/linux/inotify_stubs.c && \
    make UISTYLE=text NATIVE=true STATIC=true && \
    cp /tmp/unison-${UNISON_VERSION}/src/unison /tmp/unison-${UNISON_VERSION}/src/unison-fsmonitor /usr/local/bin && \
    # Remove build tools
    apk del build-base curl ocaml && \
    # Remove tmp files and caches
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/unison-${UNISON_VERSION}

# USER nginx:nginx
ADD ./entrypoint.sh /opt/bin/

VOLUME ["/mnt/app_data","/var/app_data"]

HEALTHCHECK --interval=30s \
	--start-period=5m \
	--retries=3 \
	--timeout=1s \
	CMD F=.sync-check.$RANDOM && \
		touch /var/app_data/${F} && \
		sleep 1 && \
		rm /mnt/app_data/${F}

ENTRYPOINT ["/opt/bin/entrypoint.sh"]
