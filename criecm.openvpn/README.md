# install OpenVPN / FreeBSD

## vars
  * openvpn_key_files

## files
 files/openvpn/openvpn.conf
 files/openvpn/ta.key
 files/openvpn/ssl/{{ openvpn_key_files }}

## multi-profiles

si `openvpn_configs` = [ 'udp','tcp' ]

files:
  - files/openvpn/openvpnudp.conf
  - files/openvpn/openvpntcp.conf
