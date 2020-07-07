#!/bin/bash

[ -z $NODENAME ] && echo "NODENAME env required" && exit 1
[ -z $ADVERTISE_PORT ] && echo "ADVERTISE_PORT env required" && exit 1
[ ! -d $NODENAME ] && mkdir $NODENAME
echo > $NODENAME/$ADVERTISE_PORT

exec unison -socket 9999
