#!/bin/bash

unison  -socket 9001
unison 	-root /mnt/app_data/cacheable \
	-root /var/app_data \
	-repeat watch \
	-prefer newer 
