#!/bin/sh
#
# get "manuf" file as in wireshark < 4.2
# and update it
#
[ -d ~/getoui ] || mkdir -p ~/getoui
cd ~/getoui
if [ ! -e tools/make-manuf.py ]; then
  mkdir -p tools
  fetch -mq -o tools/make-manuf.py https://raw.githubusercontent.com/wireshark/wireshark/refs/heads/release-4.0/tools/make-manuf.py
  fetch -mq https://raw.githubusercontent.com/wireshark/wireshark/refs/heads/release-4.0/manuf.tmpl
fi
(cd tools; python make-manuf.py) > make-manuf.log
cp manuf /usr/local/www/nginx/manuf
chmod 644 /usr/local/www/nginx/manuf
