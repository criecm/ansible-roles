Role Name
=========

Install cron entries

Requirements
------------

Useable unix system with cron

Role Variables
--------------

  * `crons`,`host_crons`,`role_crons` (`[]`):
    list of dicts for cron module
  * `cronvars ({})`:
    dict of crontab(5) variables

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: criecm.crons, crons: [ { name: 'my own cron', job: 'echo "cron does work"', hour: '*/3', minute: '42' } ] }

License
-------

BSD

Author Information
------------------

https://dsi.centrale-med.fr
