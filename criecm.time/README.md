Role Name
=========

Sets time client from ntp or local source

Won't do anything in host is a container or jail

Requirements
------------

none

Role Variables
--------------

* `ntp_servers ([])`
* `ntp_pools (["pool.ntp.org"])`
* `ntp_use_ptp_kvm (True)`: only when in a linux kvm guest, use host's clock using PHC source instead of ntp servers/pools
* `ntp_listen_addrs ([])`: list of IPs to listen (none by default)
* `ntp_tos_min_clock (4)`: tos minclock for ntp
* `ntp_tos_min_sane_clock (3)`: tos minsane
* `ntp_tos_max_clock (11)`: tos maxclock for ntp

Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: criecm.time, ntp_servers: [ fr.pool.ntp.org ] }

License
-------

BSD

Author Information
------------------

https://dsi.centrale-med.fr/
