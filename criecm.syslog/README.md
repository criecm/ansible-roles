Role Name
=========

configure central syslog server

Role Variables
--------------

  * `syslog_server ('')`
    IP/name of syslog server (IP recommended !) - do nothing if empty
  * `syslog_auth_server (syslog_server)`
    different syslog for auth data

Dependencies
------------

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: criecm.syslog, syslog_server: '10.0.5.14' }

License
-------

BSD

Author Information
------------------

Yet another sysadmin
