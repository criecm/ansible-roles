# criecm.munin

Install/config/update munin-master and/or munin-node

for each host in inventory

## Requirements

FreeBSD or Debian

## Variables (default value)

### usefull
  * `munin_plugins` ([])
    list of plugin files to link. Can be folowwed by a space and plugin name
    eg:
        - '/usr/local/share/munin/plugins/if_err_ if_err_bxe0'
        - 'if_err_ if_err_bxe0'
    when path is not absolute, relative to `munin_dist_plugins`
  * `munin_configs` ({})
    dict of config for node (key is filename and value is content)
  * `munin_config_files` ([])
    list of config files to copy on node
  * `munin_servers` ([])
    Ip's of munin master node(s). Will allow these IP addresses on node
  * `munin_host` ('')
    if equal to `inventory_hostname`, will install master
  * `do_cleanup` (False)
    If `True` will supress (in all it installed before):
    * `ansible-host-*.conf` that does not match current inventory
    * `ansible-aggr-*.conf` that does not match templates
      in templates/munin/
  * `munin_async_key` ('')
    ssh public key for munin-async
    If provided, munin-asyncd daemon will be used, with ssh access in lieu of tcp:4949

### for information/hacking
  * `munin_host_dir` ({{ prefix }}/munin-conf.d)

## Aggregations templates

Aggretation templates found in templates/munin/aggr/* will be installed as 'ansible-aggr-{{ part of basename before . }}' on munin_host

Note you'll have to call criecm.munin on munin_host explicitely to install them

## Example Playbook

    # this playbook will install munin-master on `mymaster` and munin-node on all hosts
    - hosts: all
      roles:
         - criecm.munin
      vars:
        munin_host: mymaster
        munin_servers:
          - 192.0.2.3
          - 203.0.113.18
        munin_plugins:
          - 'snmp__if_multi snmp_{{ ansible_fqdn | regex_replace("\.","_") }}_if_multi'
          - '/my/own/munin/plugin'
        munin_configs:
          myplugin: |
            [myplugin]
            user myuser
            env.myvar myvalue
        # same as above with config in a file
        munin_config_files:
          - files/munin/myplugin.conf


License
-------

BSD

Author Information
------------------

https://github.com/criecm/
