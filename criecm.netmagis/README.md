Horde
=====

Install netmagis

Requirements
------------

* postgresql server and database (not managed here), can use pgsql variable

Role Variables
--------------

### Mandatory

* `netmagis_default_domain` ('localdomain')
  Default netmagis domain …
* `netmagis_http_host` ('netmagis.localdomain')
* `pgsql` ({}) - dict
  * `host`: db host
  * `port` (5432): database port
  * `user`: db user
  * `passwd`: db passwd

### Optionnal

* `netmagis_rootusers` (['admin'])
  Admin users
* `netmagis_socket` ('unix:/var/run/fcgiwrap/netmagis.sock')
  Socket between netmagis daemon and nginx
* `netmagis_zonesdir` ('/var/netmagis/dnsmaster')
  Zones directory
* `netmagis_dhcpd_file` ('/var/netmagis/dhcpd-gen.conf')
  dhcpd file generated
* `netmagis_dhcpd_failover` ('')
  string added to dhcp pools for ISC DHCPD failover mechanism
* `netmagis_dhcpd_check_cmd` ('/usr/sbin/service isc-dhcpd configtest')
  dhcpd config check
* `netmagis_dhcpd_cmd` ('/usr/sbin/service isc-dhcpd restart')
  dhcpd reload command
* `netmagis_zonecmd` ('/usr/local/sbin/nsd-control reload')
  zones reload command
* `netmagis_cron_user` ('root')
  crons user
* `netmagis_cron_dns` ('{{ prefix }}/sbin/mkzones')
  program to run for zones generation
* `netmagis_cron_dhcp` ('{{ prefix }}/sbin/mkdhcp')
  program to run for dhcpd config generation
* `prefix` (/usr)
  use /usr/local here on freebsd

Dependencies
------------

* nginx
* dhcpd
* nsd

Example Playbook
----------------

Simple one:

    - hosts: magis

      roles:
        - netmagis

      vars:
        pgsql: { host: 'mydbhost', port: '5432', user: 'magis', passwd: 'NetMagisPassword' }
        netmagis_http_host: 'netmagis.univ.fr'
        netmagis_default_domain: 'test.univ.fr'
        sysadmin_mail: netmagis@univ.fr
        nsd_patterns:
          - { name: magismaster, notify: [ "192.0.2.3 NOKEY", "198.51.100.2 NOKEY" ], provide-xfr: [ "192.0.2.3 NOKEY", "198.51.100.2 NOKEY" ] }
        nsd_zones:
          - { name: 'niceusers.univ.fr.', masters: ['192.0.2.3'], pattern: magismaster }
          - { name: 'others.univ.fr.', masters: ['192.0.2.3'], pattern: magismaster }

License
-------

BSD

Author Information
------------------

Geoffroy Desvernay for Ecole Centrale de Marseille
