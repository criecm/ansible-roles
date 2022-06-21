# nginx

nginx web server, with one to many websites, for FreeBSD 11,12 and Debian 9,10

* `conf.d/` ready
* `modules.d/*.conf` for dynamic modules
* list of networks `proxified_by` will be trusted as reverse-proxy
  * include HTTPS support for fastcgi

## Features

* nginx on FreeBSD, Debian
* default server
* monitoring (on `/nginx_status` for `{monitoring_from}` IP's)
* syslog if wanted

## Examples

### minimal example:

```yaml
- hosts: webhost1
  roles:
    - nginx
  vars:
    sites:
      # this will create an empty website hosted in /home/mysite/mysite:
      - { id: mysite, name: website.example.org }
      # another one hosted in /usr/local/www/other:
      - { id: myothersite, name: othersite.example.org, rootdir: /usr/local/www/other }
```

### separate reverse-proxy:

```yaml
# backend
---
# of course this one may need criecm.node, criecm.tomcat, criecm.php-fpm or …
# and contain many hosts
- hosts: backends
  roles:
    - criecm.nginx
  vars:
    sites:
      - id: myfirstbackend
        name: mfb.example.org
        nginx_includes: [myconf.conf.j2]

# reverse-proxy
- hosts: relays
  roles:
    - criecm.nginx
  vars:
    # monitoring hosts (allowed to access /nginx_status)
    monitoring_from:
      - 198.51.100.3
      - 2001:DB8:ad31::b0b0:c001

    # will register https from reverse proxy
    proxified_by:
      - 2001:DB8:1ee7::654:3/128
      - 203.0.113.8/32

    sites:
      # this one will reverse-proxy, HTTPS and load-balancing
      #  between backends
      - id: mfb-proxy
        name: mfb.example.org
        tls_cert: files/tls/mycert.crt
        tls_key: files/tls/private/mycert.key
        # we want all http redirected to https:
        tls_redir: True
        # activate stapling
        x509_stapling_chain: files/tls/stapling.pem
        # this will load-balance, with sticky sessions by default (site.conf.j2)
        backends:
          - http://backend01.example.org
          - http://backend02.example.org
          - http://backend03.example.org
```

## Role Variables

### global (default value)

* `nginx_processes (1)`
   as in nginx.conf
* `error_loglevel (info)`
* `www_default_root (platform dependant)`
* `nginx_log_dir (/var/log/nginx)`
* `sites ([])`
  list of sites dicts (see below)
* `nginx_status_path ('/nginx_status')`
* `monitoring_from ([127.0.0.1])`
* `admin_from ([])`
  ip addresses/networks allowed to access monitoring pages
* `nginx_includes ([])`
  list of templates (or files) to be 'include'd in http block (conf.d/)
* `nginx_modules ([])`
  nginx modules to load explicitly (eg: `["ngx_http_auth_pam_module","ngx_http_geoip_module"]`)
* `nginx_mods_includes ([])`
  list of templates to be included *before* http block (modules.d/)
* `backends ([])`
  list of backend lines for upstream
* `backend ('')`
  if defined, criecm.nginx will skip it 
  (let another role enrich it before calling out vhost.yml by himself — see below)
* `nginx_debian_package (nginx)`
  Debian package for nginx (nginx-full, nginx-lite, …)
* `syslog_server ('')`
  nginx will log errors there
* `syslog_facility (local5)`:
* `do_local_log (True)`:
  keep logs locally
* `do_local_access_log (do_local_log)`;
  keeps access log locally
* `do_http2 (False)`
  activate http2 when using tls
* `mysite ('')`:
  if defined, will only process this `site.id`
* `nginx_default_site ('default')`
  set it to '' to prevent default site to be installed
* `nginx_aio (off)`
  use aio (asynchronous file I/O (AIO) on FreeBSD and Linux) - for big files
* `nginx_sendfile (on)`
  use sendfile (mmap files)
* `nginx_tcp_nopush (on)`
  use tcp_nopush (you want it with sendfile for zero-copy)
* `nginx_tcp_nodelay (on)`
  use tcp_nodelay (do not wait for tcp packets to be filled)

### if behind reverse-proxy

* `proxified_by` ([])
  list of networks to be trusted as reverse-proxies:
  - HTTPS accelerator included via X-Forwarded-Proto header
  - original client IP kept via realip module
  Can be overriden per site

### per-site variables (site.X)

#### mandatory (can't work without…)

* `id` (no default) 
  unique (per host) short name used everywhere by default
* `name` (no default)
  DNS name

#### optional (default values may suffice)

* `rootdir` (/home/{{id}}/{{id}})
  site root (code)
* `webroot` (rootdir)
  alternative web root if needed
* `listen` ([80|443])
  list of port or ip:port's to listen to
* `default_index ('index.html index.htm')`

#### optional (no default)

* `aliases ([])`
  server aliases
* `nginx_includes`
  files or templates included inside `server {}` block
  see *Files / Templates locations* for path
* `upstream`
  allows to fix upstream name (for reuse in template/prefixes)

##### TLS / HTTP2

* `hsts` (31536000 if `x509_cert`, else 0)
  if > 0, add Strict-Transport-Security header
* `tls_redir` (False)
  if True, redirect all http requests to https
* `tls_cert` (NODEFAULT)
  x509 certificate (with intermediate certs)
* `tls_key` (NODEFAULT)
  private key for tls/http2
* `x509_stapling_chain` ('')
  complete ca chain for stapling
  (from root CA to last intermediate)
* `http2 (do_http2)`
  activate http2 when using tls

## Files / Templates locations

All files matching `playbooks/files/{{id}}/nginx/conf.d/*.conf` will be copied in nginx's conf.d directory and included in 'http {}' context

The first file found in this list will be used as site config (per site)

- `playbooks/templates/{{id}}/site.conf.j2`
- `playbooks/files/{{id}}/site.conf`
- `playbooks/templates/{{inventory_hostname without last digit}}/{{id}}.conf.j2`
- `playbooks/files/{{inventory_hostname without last digit}}/{{id}}.conf`
- `roles/nginx/templates/site.conf.j2`

For `includes` files, they will be searched in (first match wins):

- `playbooks/templates/{{id}}/nginx/`
- `playbooks/files/{{id}}/nginx/`
- `playbooks/files/{{inventory_hostname without last digit}}/nginx/`
- `playbooks/files/{{inventory_hostname without last digit}}/nginx/`

other relative paths (`x509_cert`, …) will be searched "normally"
(https://github.com/ansible/ansible/issues/14341#issuecomment-234559431)

## Use from another role
You can call site.yml directly with:

        - include_role:
            name: criecm.nginx
            tasks_from: vhost.yml
          vars:
            vhost: '{{ site }}'

It's already integrated with criecm.php-fpm if ever ;)
