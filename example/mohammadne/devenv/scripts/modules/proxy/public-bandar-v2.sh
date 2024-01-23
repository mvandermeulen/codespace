#!/bin/bash

info() {
	echo -n "setup public-bandar-v2 proxy"
}

run() {
	local cert_url="http://public-bandar-v2.compute.sotoon.ir/cert.crt"
	local certfile_name="public-bandar-v2.crt"

	curl -v $cert_url > /usr/share/ca-certificates/$certfile_name
	echo $certfile_name >> /etc/ca-certificates.conf
	update-ca-certificates --fresh

	# vim /etc/systemd/system/docker.service.d/http-proxy.conf
}
