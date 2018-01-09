# criecm.nfs_server

NFS server

Will 
  * enable nfs daemons
  * fix ports of NFSv3 services
  * enable nfsuserd to map uid<->uidnumbers
  * create exports blocks in /etc/exports for each share
    when share.nfs == True

Requirements
------------

FreeBSD

Role Variables
--------------

* `shares` ([]): list of "share" dicts

Dependencies
------------


Example Playbook
----------------

    - hosts: servers
      roles:
         - criecm.nfs_server
      vars:
        shares:
          - name: "myshare"
            path: "/shares/t"
            nfs: True
            nfsshares:
              - "-maproot=0 -network 2001:0DB8:fe43:ff44:/64"
              - "-network 192.0.2.0/24"

License
-------

BSD

