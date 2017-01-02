# Ansible @ ECM

## Roles ansible Centrale Marseille:

Prévus pour Debian, FreeBSD, OpenBSD

## Prérequis

[lire la doc](http://docs.ansible.com/ansible/intro_getting_started.html "getting started")

  * un 'inventory' ([/usr/local]/etc/ansible/hosts, voir ~/.ansible.cfg ou [/usr/local]/etc/ansible/ansible.cfg)
> machine1
> machine2
  * **une cle ssh** permettant de se connecter a chaque machine de l'inventory
    (en root ou en --ansible-user=\* avec --become=[sudo|su|pbrun|pfexec|runas|doas|dzdo])

## Usage

1. definir les variables necessaires (voir `group_vars/EXEMPLE.yml`)
2. copier *playbook-all.yml* et y définir les rôles par groupe (si necessaire)
3. lancer `ansible-playbook playbook-my.yml`

## Rôles

### common

  * CA x509
  * client OpenLDAP + config
  * config mail relay (**sauf groupe "relaimail"**)
    * Debian: postfix
    * FreeBSD: sendmail
    * OpenBSD: smtpd
  * lignes de config sshd (en variables, voir defaults/main.yml)
  * syslog centralisé:
    * sauf si `is_syslogd=True`
    * seulement si `syslog_server` existe
  * deploiement des cles ssh `files/cles_ssh/*.pub` (+env `DSI=$user`)
  * /usr/local/admin/sysutils/common depuis GIT (et plus selon variables)
  * cron daily/weekly ecm (et supression des anciens de CVS)
  * snmpd (TODO: Debian et OpenBSD)
  * zsh pour root + config + aliases
  * packages supplementaires (variable pkgs)
    
### ldap_client

Comptes UNIX via LDAP (nslcd) (Debian,FreeBSD)

  * pam_ldap_services: les services pour lesquels activer PAM (aucun par defaut)

### nfs_client

NFS (v3+v4) client
ports fixes (FreeBSD,Debian)

  * statd - port 4047
  * lockd - port 4045
  * nfs client callback - port 4048
  * idmap/nfsuserd domain `{{ idmap_domain }}`
  * workaround statd port bug on Debian (patch /usr/sbin/start-statd)

#### en option, automontage LDAP/autofs (FreeBSD only for now)

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

### nginx

Serveur nginx, un vhost par défaut

  * rep `conf.d/` ready
  * rep `modules.d/*.conf` pour les eventuels modules
  * variable `proxified_by` si reverse-proxy

### dhcpd

Serveur isc-dhcpd, config a faire dans dhcpd.conf.local

### nsd

Serveur dns 'nsd', avec un/des patterns pour gérer les zones
avec `nsd-control (add|delete)zone $ZONE $PATTERN`

### netmagis

Installe netmagis, en utilisant les rôles précédents

### iocage

Installe une "machine a jails"

Installe aussi des jails iocage :)

### sas

Quelques finesses pour les sas:
  * users locaux (donnees a tenir a jour dans le playbook et playbook/files)
    * restauration des homes
    * mdp
    * restauration crontabs locaux
  * shells '/bin/bash' et '/bin/zsh'
  * config muttrc
  * xauth
