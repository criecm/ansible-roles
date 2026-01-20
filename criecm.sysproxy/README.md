# criecm.sysproxy

configure system http proxy

sets http_proxy, HTTPS_PROXY, NO_PROXY variables globally

## Role Variables

  * `http_proxy ('')`
    url of system proxy
  * `no_proxy ('[::1],localhost,127.*')`
    NO_PROXY expression for direct access

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: criecm.sysproxy, http_proxy: https://my.proxy:3129, no_proxy: '[::1],localhost,127.*,.localdomain' }

License
-------

BSD

Author Information
------------------

Yet another sysadmin
