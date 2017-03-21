# nginx

Serveur nginx, un vhost par défaut

* rep `conf.d/` ready
* rep `modules.d/*.conf` pour les eventuels modules
* list of networks `proxified_by` will be trusted as reverse-proxy
  * include HTTPS support for fastcgi

## ssl/TLS support:

* `x509_cachain` for stapling - complete ca chain (from root to last CA before certs)

### per site:

* TLS si `do_tls` == True
  * `x509_cert` par site
  * `x509_key` par site
