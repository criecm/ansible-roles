Role Name
=========

Configure system default mailer

  * Debian: postfix
  * FreeBSD: dma
  * OpenBSD: smtpd

Requirements
------------

Debian, FreeBSD or OpenBSD system

Role Variables
--------------

  * `is_mailrelay` (False)
    Does not configure mail relay if True
  * `host_mailrelay` ()
    If defined, name/IP of the mail relay - if not empty this will skip `mailrelays` selection mechanism
  * `rootmailto ()`
    email to forward root's mails to
  * `mailaliases (/etc/aliases)`
    mail alias file

Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: criecm.mailrelay, host_mailrelay: smtp.my.provider }

License
-------

BSD

Author Information
------------------

https://dsi.centrale-med.fr/
