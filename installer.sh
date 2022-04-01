#!/bin/bash

# check if run as superuser
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

curl -sL "https://github.com/napkindrawing/raspberrypi_exporter/archive/master.zip" > "/tmp/raspberrypi_exporter.zip"
unzip -qq -o "/tmp/raspberrypi_exporter.zip" -d "/tmp"

[ -d "/var/lib/node_exporter" ] || mkdir -p "/var/lib/node_exporter"

mv "/tmp/raspberrypi_exporter-master/raspberrypi_exporter" "/usr/local/sbin/"
chmod +x "/usr/local/sbin/raspberrypi_exporter"

mv "/tmp/raspberrypi_exporter-master/raspberrypi_exporter.service" "/etc/systemd/system/"
mv "/tmp/raspberrypi_exporter-master/raspberrypi_exporter.timer" "/etc/systemd/system/"

systemctl stop raspberrypi_exporter.timer
systemctl disable raspberrypi_exporter.timer

systemctl daemon-reload
systemctl enable raspberrypi_exporter.timer
systemctl start raspberrypi_exporter.timer

rm -f "/tmp/raspberrypi_exporter.zip"
rm -rf "/tmp/raspberrypi_exporter-master"
