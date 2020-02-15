# install OpenVPN / FreeBSD

## vars
  * openvpn_key_files

## files
 files/openvpn/openvpn.conf
 files/openvpn/ta.key
 files/openvpn/keys/{{ openvpn_key_files }}

## multi-profiles

si `openvpn_configs` = [ 'udp','tcp' ]

files:
  - files/openvpn/openvpn_udp.conf
  - files/openvpn/openvpn_tcp.conf
