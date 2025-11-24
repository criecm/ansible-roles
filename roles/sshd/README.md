Role Name
=========

Sets sshd server config and deploy/remove authorized keys

Requirements
------------

none

Role Variables
--------------

* `{{ ssh_keys_dir }}` can be a directory containing ssh keys to add (.pub) 
  or delete (.del) from root's `.ssh/authorized_keys`
  * Files matching `{{ ssh_keys_dir }}/*.pub` will be authorized on root account
  * Files matching `{{ ssh_keys_dir }}/*.del` will be removed
* `sshd_allow_groups ('')`
  define AllowGroups in `/etc/ssh/sshd_config`
* `sshd_lines ([])`
  list of dicts for lineinfile
* `default_sshd_lines ([])`
  same, added to `sshd_lines` (for global or group use)
* `ssh_backup_dir ('')`
  if present, files matching `{{ ssh_backup_dir }}/ssh_host.*_key(.pub)?` will be installed as host keys if present
  example: `ssh_backup_dir: 'files/backup/{{ inventory_hostname }}/ssh'`

Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: criecm.sshd }

License
-------

BSD

Author Information
------------------

https://dsi.centrale-med.fr/
