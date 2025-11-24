Role Name
=========

Get collection of git repos sychronized

Requirements
------------

git

Role Variables
--------------

  * `gits_root (/root)`: base path to clone repositories
  * `gits_group ('')`: group that should own repositories
  * `gits_mode ('0750')`: chmod value for gits dirs
  * `gits`, `host_gits`, `group_gits` and `role_gits` ([])
    lists of dicts: each MUST have at least
      * `repo`: git url to clone there
      * `dest`: destination path (absolute or relative to gits_root)
    and MAY have:
      * `umask` ('0022')
      * `update` (False)
      * `version` (master)
  * `git_ssh_key ('')`: ssh key to use to clone git repositories (if needed)

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: criecm.sysutils, gits: [ { repo: https://git.server/repo.git, dest: mytools, version: production } ] }

License
-------

BSD

Author Information
------------------

https://dsi.centrale-med.fr
