# Role pour install apache ET sites

apache install with different sites

## files used if existing

### config files
* modules config files
  All modules.d/*.conf (for FreeBSD) or mods-enabled/*.conf (Debian) files found in:
  * apache/
  * `inventory_hostname| with numbers stripped from end`/apache
  * `inventory_hostname`/apache
  will be installed

* same for Includes/*.conf (FreeBSD) or conf.d/*.conf (Debian)

* same for *.inc installed in apache's conf dir (to be included in sites configs)

### data
* same order, but "first match wins" and recursive copy for default root directory:
  - `inventory_hostname`/apache/default_root/
  - `inventory_hostname with ending numbers stripped`/apache/default_root/
  - apache/default_root/

## variables (default)

* `sites` ([])
  Array of sites descriptions, see below
* `monitoring_from` ([127.0.0.1])
* `admin_from` ([])
  ip addresses/networks allowed to access monitoring pages

## per site variables (default value)

### mandatory
* `id` (no default)
  unique short identifier (base for dirnames, usernames, etc.)
* `name` (no default)
  DNS name
* `backends` ([])
  eg: ``` - 'ajp://jentest1.nettest.egim:8009 route=jentest1 timeout=20 loadfactor=100'```
  - if only one is defined, see https://httpd.apache.org/docs/2.4/mod/mod_proxy.html 
    eg: ``` - 'http://my.backend.local:8080/'
  - if more than one, see https://httpd.apache.org/docs/2.4/mod/mod_proxy_balancer.html
    eg: 

### optional (sane defaults)
* `rootdir` (system-dependant/{{name}})
  You have to populate it elsewhere (criecm.php-fpm does it from vars, or in your playbook)
* `listen` (`*:80` or `*:443`)
  IP:port or port to listen (default depends of `tls_cert` presence)
* `user` (system dependant default)
* `group` (same)
* `status_path` (/apache-status)
  will present apache status page to `monitoring_from` and `admin_from` nets, if thay are populated
  and `status_path` is not empty

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

### TLS : https support
* `tls_cert` ([])
  file name, will be searched for in files/tls/ ans copied in {prefix}/etc/ssl/
* `tls_key` ([])
  file name, will be searched for in files/tls/ ans copied in {prefix}/etc/ssl/private/
* `tls_hsts` (15768000)
  will add a Strict-Transport-Security header with provided value
* `tls_redir` (False)
  will define an http vhost redirecting to https if True

# Files / Templates locations
From vars/site.yml:
```
siteconf_locations:
  - '{{ playbook_dir }}/templates/{{ id }}/apache/{{ id }}.conf.j2'
  - '{{ playbook_dir }}/files/{{ id }}/apache/{{ id }}.conf'
  - templates/site.conf.j2

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
      - id: webperso
        name: site.domain.example
        apache_includes:
          - site_example.inc
          - favicon.inc
        rootdir: /usr/local/www/default
      - id: rproxy
        name: www.my.univ.fr
	listen: 443
	tls: True
	tls_redir: True
        aliases:
          - my.univ.fr
          - univ.fr
        backends:
          - 'http://my.backend.internal:8090/'
```
