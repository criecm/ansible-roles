Role Name
=========

wordpress install

Requirements
------------

Role Variables
--------------

* `sites ([])`: list of dicts for each wordpress install, as used by criecm.nginx and criecm.php_fpm roles, plus

* `mysite ('')`: if defined, only this site will be processed

Sites variables
---------------

For each site, may contain:
* `wp_plugins ([])`: list of wordpress plugins to be installed
* `wp_themes ([])`: same for themes
* `wp_config ({})`: dict of configuration items to be inserted in wordpress config file

Dependencies
------------

criecm.nginx
criecm.common

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
