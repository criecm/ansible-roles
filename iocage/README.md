# iocage

iocage host install/config and jails installation

see defaults/main.yml for defaults

## playbook for host and one jail:
<code><pre>
- hosts: realmachine
  roles:
    - iocage
  vars:
    jail_list:
      - { tag: myjail, hostname: myjail.my.domain, ip4: 'bge0|192.168.0.10' }
</pre></code>
