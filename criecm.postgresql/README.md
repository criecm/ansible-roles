# PostgreSQL

Install/upgrade/setup postgresql on FreeBSD

## Requirements

FreeBSD machine (or jail or ?)

## Role Variables (default value)

* `pg_admin_user (admin)`:
* `pg_admin_password ('')`:
  You *need* to set this one
* `pg_admin_host` ('localhost')
  IP or network to allow admin user from in pg_hba.conf
* `pg_allowed_hosts` ([])
  list of adresses allowed to connect to any DB with any user
* `pg_version (detected or 13)`:
* `pg_upgrade (False)`:
  Version changes won't occur unless you make it True and accept the risk
* `pg_basedir (/var/db/postgres)`:
* `pg_datasubdir (data{{ pg_version }})`:
* `pg_owner (postgres)`:
* `pg_group (postgres)`:
* `pg_zfs_base ('')`:
  if any, will create datasets/set recordsize to 8K
* `pg_users ([])`:
  Users to be created, dict with keys 'db', 'name','password', 'priv'
  ( like in http://docs.ansible.com/ansible/latest/postgresql_user_module.html )
  + 'hosts ([all])' (to be added to pg_hba.conf)
* `pg_maintenance_users ([])`:
  like above, but to be defined globally
* `pg_dbs ([])`:
  List of databases to create (list of dicts with keys 'name')
  eg:
    pg_dbs:
      - { name: mydb, owner: mydbuser }
      - { name: mydb2 }
* `pg_tmp_dump (/tmp/pg.sql)`
  When `pg_upgrade`, specify temp file path

* `pg_config ({})`:
  dict of specifig config vars, added to postgresql.conf after templating

### for postgresql.conf default template
* `pg_listen_ip ('*')`:
  IP (or IPs comma-separated) to bind to
* `pg_listen_port (5432)`:
  tcp port
* `pg_logdest (syslog)`:
* `pg_syslog_facility (local3)`:
* `pg_logdir ('pg_log')`:
  Logs will be written here if `pg_logdest` is "stderr"
* `pg_lc ('en_US.UTF-8')`:
  Default language for all, can be overriden by:
  * `pg_lc_messages`
  * `pg_lc_monetary`
  * `pg_lc_numeric`
  * `pg_lc_time`
* `pg_text_search_config ('pg_catalog.english')`:

Example Playbook
----------------

Simple postgresql on ZFS setup

    - hosts: servers
      roles:
         - { role: criecm.postgresql, pg_admin_password: '42', pg_zfs_base: 'zdata/pgsql' }

Create user (and db)

    - hosts: dbhosts
      roles:
        - criecm.postgresql
      vars:
        pg_admin_password: '42'
	pg_zfs_base: 'zdata/pgsql'
	pg_users:
	  - name: app1
	    password: secret
	    db: db1
	    hosts: [ 10.2.5.0/24 ]

Create db and some users
    - hosts: dbhosts
      roles:
        - criecm.postgresql
      vars:
        pg_admin_password: '42'
        pg_zfs_base: 'zdata/pgsql'
        pg_dbs:
          - name: db1
            owner: app1
	  - name: otherdb
	    owner: app1
        pg_users:
          - name: app1
            password: secret
            db: db1
            hosts: [ 10.2.5.0/24 ]
          - name: app2
            password: secret
            db: db1
            hosts: [ 10.2.5.0/24 ]
	    priv: 'SELECT/table1:INSERT'

License
-------

BSD

