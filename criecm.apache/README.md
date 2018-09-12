# Role pour install apache ET sites

apache with sites configs

## files used if existing

### config files/templates location

#### auto-installed config files

  * For these paths:
    - `files/{{ inventory_hostname }}/apache/`
    - `files/{{ any_group_of_this_machine }}/apache/`
    - `files/{{ inventory_hostname | regex_replace("[0-9]*$","") }}/apache/`
    - `files/apache/`

    All maching files will be installed under apache config dir:
    * FreeBSD:
    - `modules.d/*.conf`
    - `Includes/*.conf`
    * Debian:
    - `mods-enabled/*.conf`
    - `conf.d/*.conf`
    * All:
    - `*.inc`

### data files
* same order, but "first match wins" and recursive copy for default root directory:
  - `inventory_hostname/apache/default_root/`
  - `(inventory_hostname with ending numbers stripped)/apache/default_root/`
  - `apache/default_root/`

## variables (default)

* `sites ([])`:
  Array of sites descriptions, see below
* `monitoring_from ([127.0.0.1])`:
  ip addresses/networks allowed to access status pages
* `admin_from ([])`:
  ip addresses/networks allowed to access status/balancer-manager pages
* `mysite ('')`:
  if defined, only process this site.id instead of each `sites`

## per site variables (default value)
Most of these are used in bundled site.conf.j2 template only, except `id`, `apache_includes`, `rootdir`, `user/group`, `grwfiles/dirs` and `tls_key/cert`

### mandatory
* `id (MANDATORY)`:
  unique short identifier (base for dirnames, usernames, etc.)
* `name (MANDATORY)`:
  DNS name
* `backends ([])`:
  eg: ``` - 'ajp://jentest1.nettest.egim:8009 route=jentest1 timeout=20 loadfactor=100'```
  - if only one is defined, see https://httpd.apache.org/docs/2.4/mod/mod_proxy.html 
    eg: ``` - 'http://my.backend.local:8080/'
  - if more than one, see https://httpd.apache.org/docs/2.4/mod/mod_proxy_balancer.html
    eg: 

### optional (sane defaults)
* `rootdir (system-dependant/{{name}})`:
  You have to populate it elsewhere (criecm.php-fpm does it from vars, or in your playbook)
* `listen (*:80 or *:443)`
  [IP:]port or port to listen (default depends of `tls_cert` presence)
* `user (system dependant default)`
* `group (user)`
* `status_path (/apache-status)`:
  will present apache status page to `monitoring_from` and `admin_from` nets, if they are populated
  and `status_path` is not empty
* `prefixes ([{path: /}])`:
  list of pathes allowed on this virtualhost. You may list IP networks allowed in `allow_from_nets` element
  skipped if `apache_includes` is defined/not empty

### options (none by default)
* `aliases ([])`:
  DNS aliases (ServerAlias'es)
* `apache_includes ([])`
  Files to be included in virtualhost config.
  see *Files / Templates locations* for searched path
* `grwfiles ([])`
  files writeable by group
* `grwdirs ([])`
  dirs writable by site's group

### TLS : https support
* `tls_cert ([])`:
  file name, will be searched for in files/tls/ and copied in {prefix}/etc/ssl/
* `tls_key ([])`:
  file name, will be searched for in files/tls/ and copied in {prefix}/etc/ssl/private/
* `tls_hsts (15768000)`:
  will add a Strict-Transport-Security header with provided value
* `tls_redir (False)`:
  will define an http vhost redirecting to https if True

# Files / Templates locations
From vars/site.yml:
```
siteconf_locations:
  - '{{ playbook_dir }}/templates/{{ id }}/apache/{{ id }}.conf.j2'
  - '{{ playbook_dir }}/files/{{ id }}/apache/{{ id }}.conf'
  - templates/site.conf.j2 # bundled

# used for apache_includes vars:
include_locations:
  - '{{ playbook_dir }}/templates/{{ id }}/apache/{{ item }}.j2'
  - '{{ playbook_dir }}/files/{{ id }}/apache/{{ item }}'
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
      - proxy_ajp
      - proxy_balancer
      - proxy
      - ssl
      - lbmethod_byrequests
      - lbmethod_bytraffic
      - lbmethod_bybusyness
      - slotmem_shm
      - access_compat
    sites:
      # simple site
      - id: webperso
        name: site.domain.example
        apache_includes:
          - site_example.inc # see Files / Templates locations
          - favicon.inc
        rootdir: /usr/local/www/default
      - id: rproxy
        name: www.my.univ.fr
	listen: 443
	tls: True
	tls_redir: True
        tls_cert: www.my.univ.crt # relative to playbook_dir/ssl/
        tls_key: www.my.univ.key # idem
        aliases:
          - my.univ.fr
          - univ.fr
        backends:
          - 'http://my.backend.internal:8090/'
      - id: ajpproxy
        name: apps.univ.fr
        backends:
          - 'ajp://backend1.internal:8009/'
          - 'ajp://backend2.internal:8009/'
        prefixes:
          - path: /firstapp
            allow_from_nets:
              - 192.0.2.128/25
              - 2001:db8:cafe:f001::/64
          - path: /publicapp
```
