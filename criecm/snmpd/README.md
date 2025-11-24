Role Name
=========

Install/configure snmp daemon

Requirements
------------

Debian, FreeBSD or OpenBSD

Role Variables
--------------

  * `monitoring_from ([])`: list of networks to allow for snmp (Debian only)

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: criecm.snmpd }

License
-------

BSD

Author Information
------------------

https://dsi.centrale-med.fr
