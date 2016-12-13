# NFS client with fixed ports (FreeBSD and Debian)

  * statd on port 4047
  * lockd on 4045
  * nfs client callback on 4048
  * idmap/nfsuserd domain to {{ idmap_domain }}
  * workaround statd port bug on Debian (patch /usr/sbin/start-statd)

## optionnaly, can use ldap autofs nis map (FreeBSD only for now)

Just define {{ldap_autofs_master_map}} to auto.master with the example below:

default values (defaults/main.yml) will work 
with this kind of ldap records:

```
# auto.master glue
dn: nisMapName=auto.master,ou=automount,dc=example,dc=com
nisMapName: auto.master
objectClass: nisMap
objectClass: top

# /home	auto.home
dn: cn=/home,nisMapName=auto.master,ou=automount,dc=example,dc=com
cn: /home
objectClass: nisObject
nisMapName: auto.master
nisMapEntry: auto.users

# auto.home glue
dn: nisMapName=auto.users,ou=automount,dc=example,dc=com
objectClass: top
objectClass: nisMap
nisMapName: auto.users

# info	-fstype=nfs,rw	filer:/srv/info
dn: cn=info,nisMapName=auto.users,ou=automount,dc=example,dc=com
objectClass: nisObject
nisMapName: auto.users
cn: info
nisMapEntry: -fstype=nfs,rw filer:/srv/info
```
