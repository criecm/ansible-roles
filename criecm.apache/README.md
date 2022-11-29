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
* `apache_protocols ("")`:
  you may define as per https://httpd.apache.org/docs/2.4/mod/core.html#protocols

## per site variables (default value)
Most of these are used in bundled site.conf.j2 template only, except `id`, `apache_includes`, `apache_configs`, `rootdir`, `user/group`, `grwfiles/dirs` and `tls_key/cert`

### mandatory
* `id (MANDATORY)`:
  unique short identifier (base for dirnames, usernames, etc.)
* `name (MANDATORY)`:
  DNS name

### optional (sane defaults)
* `rootdir (system-dependant/{{name}})`:
  You have to populate it elsewhere (criecm.php-fpm does it from vars, or in your playbook)
* `webroot (rootdir)`:
  If you need a different web root
* `listen ([*:80] or [*:443])`
  list of [IP:]port or port to listen (default depends of `tls_cert` presence)
* `user (system dependant default)`
* `group (user)`
* `status_path (/apache-status)`:
  will present apache status page to `monitoring_from` and `admin_from` nets, if they are populated
  and `status_path` is not empty
* `backends ([])`:
  eg: ``` - 'ajp://jentest1.nettest.egim:8009 route=jentest1 timeout=20 loadfactor=100'```
  - if only one is defined, see https://httpd.apache.org/docs/2.4/mod/mod_proxy.html 
  - if more than one, see https://httpd.apache.org/docs/2.4/mod/mod_proxy_balancer.html
  - if you define `prefixes`, backends will only be used for them.
* `apache_directives ([])`:
  list of apache config lines. MUST be valid config lines in virtualhost section
* `prefixes ([{path: /}])`:
  list of pathes allowed on this virtualhost, with
    `allow_from_nets ([])` listing IP(v4|v6) prefixes allowed
    `apache_includes ([])` as in sites
    `apache_configs ([])` as in sites
    `backends ([])` as in sites (do not forget to add the url path as ajp://jentest1.nettest.egim:8009*/there*)
    `apache_directives ([])`: as in sites, but must be valid in `<Location>`
* `protocols (apache_protocols)`:
  you may override `Protocol` per vhost - see https://httpd.apache.org/docs/2.4/mod/core.html#protocols

### options (none by default)
* `aliases ([])`:
  DNS aliases (ServerAlias'es)
* `apache_includes ([])`
  Files to be included in virtualhost config.
  see *Files / Templates locations* for searched path
* `apache_configs ([])`
  Files to be copied in apache config directory (for inclusion in your templates)
  see *Files / Templates locations* for searched path
* `grwfiles ([])`
  files writeable by group
* `grwdirs ([])`
  dirs writable by site's group
* `cache ([])`
  cache lines (Added after "CacheEnable")
* `redirectmatch ([])`
  list of redirections dicts:
    `regex`: path selector
    `dest`: destination
    `type (temp)`: "permanent", "temp", 302, 30x, …
* `gitroot ()`
  git repo to clone in rootdir
* `gitrootversion ("master")`
  git tag/branch/commit for gitroot

### TLS : https support
* `tls_cert ([])`:
  file name, will be searched for in files/tls/ and copied in {prefix}/etc/ssl/
* `tls_key ([])`:
  file name, will be searched for in files/tls/ and copied in {prefix}/etc/ssl/private/
* `tls_hsts (31536000)`:
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
  - '{{ item }}.j2'
  - '{{ item }}'
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
        prefixes:
          - path: /firstapp
            allow_from_nets:
              - 192.0.2.128/25
              - 2001:db8:cafe:f001::/64
            backends:
              - 'ajp://backend1.internal:8009/'
              - 'ajp://backend2.internal:8009/'
          - path: /publicapp
	    backends:
	      - 'ajp://backend1.internal:8009/'
	cache:
          - 'disk "/publicapp"'
```
