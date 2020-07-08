FROM swarm-manager:5000/brcms/unison

COPY ./*.sh /opt/bin/
WORKDIR /mnt/host/var/app_data

EXPOSE 9999

CMD ["./main.sh"]
