# Role Name

Manage mongodb instance

## Requirements


## Role Variables

* `mongo_root_pass (REQUIRED)`
  If defined, will be set as password for root user
* `mongo_root_user ('root')`
  Name of root user
* `mongos ([])`
  List of dicts with:
    - name: username
      database: dbname
      password: userpass
      roles: ['list','of','roles'] or 'role' (ReadWrite)
* `mongo_bindips ()`
  Ip(s) to bind. as comma-separated string
  eg: '::,0.0.0.0'
  default is to let mongod bind localhost-only
* `mongo_zfs ()`
  If defined, use this zfs for dbdir
* `mongo_global_users ([])`
  Define users globally (eg: monitoring) - same format as `mongos`

## Dependencies


## Example Playbook

Simple example:

    - hosts: mongodb
      roles:
        - criecm.mongodb
      vars:
        mongo_root_pass: 'my strong password'
	mongos:
	  - name: mongo1user
	    password: 'another strong one'
	    database: mongo1db

License
-------

BSD

Author Information
------------------

https://galaxy.ansible.com/criecm
