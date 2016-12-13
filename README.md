# Ansible @ ECM

## Roles ansible Centrale Marseille:

Prévus pour Debian, FreeBSD, OpenBSD

  * **common**
    * CA x509 dans /etc/ssl/caecm.ecm
    * client OpenLDAP + config
    * config mail relay (**sauf groupe "relaimail"**)
      * Debian: postfix
      * FreeBSD: sendmail
      * OpenBSD: smtpd
    * config sshd
      * PermitUserEnvironment yes
      * PermitRootLogin without-password
    * deploiement des cles ssh `files/cles_ssh/*.pub` (+env `DSI=$user`)
    * /usr/local/admin/sysutils/common depuis GIT
    * cron daily/weekly ecm (et supression des anciens de CVS)
    * zsh pour root + config + aliases
    
  * **ldap_client**
    * Comptes UNIX via LDAP (nslcd) (Debian,FreeBSD)

  * **nfs_client**
    * ports client NFS fixes (Debian,FreeBSD)
    * **en option** automontage LDAP (FreeBSD)

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

