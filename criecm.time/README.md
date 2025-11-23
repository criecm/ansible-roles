Role Name
=========

Sets time client from ntp or local source

Won't do anything in host is a container or jail

Requirements
------------

none

Role Variables
--------------

* `host_timezone ()`: if defined, set the host timezone
* `ntp_servers ([])`
* `ntp_pools (["pool.ntp.org"])`
* `ntp_use_ptp_kvm (True)`: only when in a linux kvm guest, use host's clock using PHC source instead of ntp servers/pools
* `ntp_listen_addrs ([])`: list of IPs to listen (none by default)
* `ntp_tos_min_clock (4)`: tos minclock for ntp
* `ntp_tos_min_sane_clock (3)`: tos minsane
* `ntp_tos_max_clock (11)`: tos maxclock for ntp
* `time_client_service (chrony for Debian, ntpd for OpenBSD, ntp for FreeBSD)`: name of service to launch
* `time_client_config (/etc/chrony/chrony.conf, /etc/ntp.conf, /etc/ntpd.conf)`: path to config file
* `time_client_package (chrony, "", ""): package to install

Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: criecm.time, ntp_pools: [ fr.pool.ntp.org ] }


Example2: force ntp install on debian

    - hosts: servers
      vars:
        time_client_config: /etc/ntp.conf
        time_client_package: ntp
        time_client_service: ntp
        ntp_pools: [ fr.pool.ntp.org ]
      roles:
        - criecm.time

License
-------

BSD

Author Information
------------------

https://dsi.centrale-med.fr/
