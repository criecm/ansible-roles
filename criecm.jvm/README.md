# jvm

FreeBSD & Debian, jdk8+

## variables (default value)

### general config

* `jvm_java_version (21)`
  Java version wanted
* `jvm_java_opts ({})` - dict
  additional global java opts (without -D)
* `jvm_net_opts ({})` (see `jvm_prefer_ipv6`) - dict
  additional java.net opts (without -D)
* `jvm_prefer_system_ipv6 (True)`
  if true AND host has IPv6, sets java.net.preferIPv6Addresses=system
  This matches all OS defaults
  (see https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/net/doc-files/net-properties.html)
  On FreeBSD, adds java.net.preferIPv4Stack=false (java default, historically overriden in some openjdk versions)
* `jvm_set_default (True)`
  On Debian, set the installed jvm as system default

### http(s) proxy support

see https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/net/doc-files/net-properties.html

* `jvm_http_proxy ('')`
  proxy for jvm HTTP connections - host:port
* `jvm_https_proxy (https_proxy | default(jvm_http_proxy))`
  proxy host:port for HTTPS connections - host:port
* `jvm_ftp_proxy (jvm_http_proxy)`
  proxy for ftp connections - host:port
* `jvm_no_proxy ('localhost|127.*|[::1]')`
  overrides for `http`, `https` and `ftp` (direct connections)

### facts
* `jre_dir` can be used by other roles (as JAVA_HOME or …)
