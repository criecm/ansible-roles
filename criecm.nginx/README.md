# nginx

nginx web server, with one to many websites, for FreeBSD 10,11 and Debian 7,8

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
<pre>
- hosts: webhost1
  roles:
    - nginx
  vars:
    sites:
      # this will create an empty website hosted in /home/mysite/mysite:
      - { id: mysite, name: website.example.domain }
      # another one hosted in /usr/local/www/other:
      - { id: myothersite, name: othersite.example.domain, rootdir: /usr/local/www/other }
</pre>

## Role Variables

### global (default value)

* `nginx_processes` (1)
   as in nginx.conf
* `error_loglevel` (info)
* `www_default_root` (platform dependant)
* `nginx_log_dir` (/var/log/nginx)
* `nginx_modules` ([])
  nginx dynamic modules to include
* `sites` ([])
  list of sites dicts (see below)
* `nginx_status_path` (`/nginx_status`)
* `monitoring_from` ([127.0.0.1])
* `admin_from` ([])
  ip addresses/networks allowed to access monitoring pages
* `nginx_includes` ([])
  list of templates (or files) to be 'include'd in http block (conf.d/)
* `nginx_modules` ([])
  nginx modules to load explicitly (eg: `["ngx_http_auth_pam_module","ngx_http_geoip_module"]`)
* `nginx_mods_includes` ([])
  list of templates to be included *before* http block (modules.d/)
* `backends` ([])
  list of backend lines for upstream
* `backend` ('')
  if defined, criecm.nginx will skip it 
  (let another role enrich it before calling out vhost.yml by himself — see below)
* `nginx_debian_package` (nginx)
  Debian package for nginx (nginx-full, nginx-lite, …)
* `syslog_server` ('')
  nginx will log errors there
* `syslog_facility` (local5)

### if behind reverse-proxy

* `proxified_by` ([])
  list of networks to be trusted as reverse-proxies:
  - HTTPS accelerator included via X-Forwarded-Proto header
  - original client IP kept via realip module

### per-site variables (site.X)

#### mandatory (can't work without…)

* `id` (no default) 
  unique (per host) short name used everywhere by default
* `name` (no default)
  DNS name

#### optional (default values can suffice)

* `rootdir` (/home/{{id}}/{{id}})
  web root
* `listen` (80)
  port or ip:port to listen to

#### optional (no default)

* `aliases` ([])
  server aliases
* `nginx_includes`
  files or templates included inside `server {}` block
  see *Files / Templates locations* for path

##### TLS / HTTP2 (all or none)

* `tls_hsts` (31536000 if `x509_cert`, else 0)
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

It's already integrated with criecm.php-fpm
