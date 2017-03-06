# tomcat

## general config
* RemoteIpValve from:
  * `reverse_proxies` (array of IP's)

* `classpath_adds`: jar's list

* `tomcat_java_opts`

* see `defaults/main.yml`

## webapps deployment
* `tomcat_webapps` is a dict of webapps to deploy
  * `key` is name
  * `war` is war file to deploy in webapps dir
  * `gitsrc` will be cloned in dir `gitdst` if both exists
  * `script` is the command line, relative to `gitdst`, to be launched (as root) user after deploying (if any)

