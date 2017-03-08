# nfs_client

NFS (v3+v4) client
ports fixes (FreeBSD,Debian)

* statd - port 4047
* lockd - port 4045
* nfs client callback - port 4048
* idmap/nfsuserd domain `{{ idmap_domain }}`
* workaround statd port bug on Debian (patch /usr/sbin/start-statd)

## en option, automontage LDAP/autofs (FreeBSD only for now)

Just define `{{ldap_autofs_master_map}}` to auto.master with the example below:

default values (defaults/main.yml) will work 
with this kind of ldap records:

<pre><code>
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
</code></pre>


