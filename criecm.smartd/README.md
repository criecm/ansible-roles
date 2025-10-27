Role Name
=========

Install/configure smartd daemon

Requirements
------------

Debian, FreeBSD or OpenBSD

Role Variables
--------------
 
  * `smart_mailto ('')`
    Here comes your email address if you wish to receive alerts by mail
  * `is_virt (True if ansible_virtualization_tech_guest[] is not empty)`
    Skip all tasks

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: criecm.smartd }

License
-------

BSD

Author Information
------------------

https://dsi.centrale-med.fr
