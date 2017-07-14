# Role pour install apache ET sites

apache install with different sites

## variables (default)

* `apache_type` ('backend')
  kind of install:
  * 'backend' no https, configs searched in `files/apache/backend/*`
  * 'rproxy' configs from `files/apache/rproxy/*`
* `sites` ([])
  Array of sites descriptions, see below

## per site variables (default value)

### mandatory
* `id` (no default)
  unique short identifier (base for dirnames, usernames, etc.)
* `name` (no default)
  DNS name

### optional (sane defaults)
* `rootdir` (system-dependant/{{name}})
* `listen` (`*:80`)
  IP:port or port to listen
* `user` (system dependant default)
* `group` (same)

### options (none by default)
* `aliases` ([])
  DNS aliases (ServerAlias'es)
* `apache_includes` ([])
  Files to be included in virtualhost config.
  see *Files / Templates locations* for searched path
* `grwfiles` ([])
  files writeable by group
* `grwdirs` ([])
  dirs writable by site's group

### TLS : TODO !

# Files / Templates locations
From vars/site.yml:
```
siteconf_locations:
  - '{{ playbook_dir }}/templates/{{ id }}/apache/{{ id }}.conf.j2'
  - '{{ playbook_dir }}/files/{{ id }}/apache/{{ id }}.conf'
  - 'templates/{{ apache_type }}/site.conf.j2'
  - templates/site.conf.j2

include_locations:
  - '{{ playbook_dir }}/templates/{{ id }}/apache/{{ item }}.j2'
  - '{{ playbook_dir }}/files/{{ id }}/apache/{{ item }}'
  - 'templates/apache/{{ apache_type }}/{{ item }}.j2'
  - 'templates/apache/{{ item }}.j2'
  - '{{ playbook_dir }}/files/apache/{{ item }}'
```

## example playbook
```
- hosts: webhost*
  roles: criecm.apache
  vars:
    apache_freebsd_modules:
      - ap24-mod_auth_cas
      - ap24-mod_rpaf2
    apache_enabled_modules:
      - rewrite
      - access_compat
    sites:
      - { id: webperso, name: site.domain.example, apache_includes: [ site_example.inc, favicon.inc ], rootdir: /usr/local/www/default }
```
