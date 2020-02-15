# install OpenVPN / FreeBSD

## vars
  * openvpn_key_files

## files
 files/openvpn/etc/openvpn.conf
 files/openvpn/etc/ta.key
 files/openvpn/etc/keys/{{ openvpn_key_files }}

## multi-profiles

si `openvpn_configs` = [ 'udp','tcp' ]

files:
  - files/openvpn/etc/openvpn_udp.conf
  - files/openvpn/etc/openvpn_tcp.conf
