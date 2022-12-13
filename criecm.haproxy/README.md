Role Name
=========

haproxy config

Role Variables
--------------

* `haproxy_proxies` mandatory
  list of proxies - see #proxy definition
* `haproxy_maxconn ('')`
  global maxconn
* `haproxy_global_config ([])`
  list of global directives
* `haproxy_defaults_config ([])`
  list of defaults directives
* `haproxy_connect_timeout ("5000ms")`
  timeout connect
* `haproxy_client_timeout ("50000ms")`
  timeout client
* `haproxy_server_timeout ("50000ms")`
  timeout server
* `admin_from ([])`
  a list of ip's/networks allowed to reach stats page
* `haproxy_stats_address ("::")`
* `haproxy_stats_port ('8888')`
  port for stats listener - disabled if empty
* `haproxy_stats_path ('/haproxy')`
  path for stats http listener

### proxy definition
A proxy definition contains:
* `name` mandatory
  short name
* `binds` mandatory
  list of bind directives, like:
    - localhost:9876 v4v6
    - 192.0.2.5:9876
    - ':::9876 v4v6'
* `options ([])` list of forntend options
* `lines ([])` lines to add as-is
* `balance ("leastconn")` type of balance
* `mode ("tcp")` proxy mode
* `clienttimeout` if different from `haproxy_client_timeout`
* `servertimeout` if different from `haproxy_server_timeout`
* `backends_port`: port for backends (needed if not defined there)
* `backends_opts`: options for each backend (can be overriden in `backend`)
* one of `backend` or `backends`:
  * `backend` is a dict based on an ansible group, contains:
    * `group` (ansible group) mandatory
    * `port` (backends's port) - default to `backends_port`
    * `opts` options to add to each backend
  * `backends` is a static list of backends, each containing:
    * `name` short name mandatory
    * `address` IP or name mandatory
    * `port` (defaults to `backends_port`)
    * `opts` (defaults to `backends_opts`)
    * `is_backup` (default to False) - mark as backup

Example Playbook
----------------

    - hosts: servers
      roles:
         - criecm.haproxy
      vars:
        haproxy_proxies:
	  # proxy based on a list
	  - name: tcpservice
	    mode: "tcp"
	    options: ["tcp-check"]
	    backends_opts: "check observe layer4 on-error mark-down" # default for each backend
	    backends_port: "9987" # default for each backend
	    backends:
	      - name: back1
	        address: 192.0.2.2
	      - name: back2
	        address: 192.0.2.3
		port: 9789 # ovveride backends_port for this one
		opts: "check" # override backends_opts for this one
		is_backup: yes
	  # proxy based on an ansible group
	  - name: groupservice
	    options: ["tcp-check"]
	    mode: "tcp"
	    backend:
	      opts: "check observe layer4 on-error mark-down"
	      group: backs # an ansible group
	      port: 9789

License
-------

BSD

Author Information
------------------

https://cri.centrale-marseille.fr
