# common - role ECM de base

* CA x509
* client OpenLDAP + config
* config mail relay (only `is_mailrelay == False and mailrelay != ''`)
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
    

