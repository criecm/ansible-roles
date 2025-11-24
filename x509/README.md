Role Name
=========

Deploy x509 CA certificate(s)

Including java certs

On FreeBSD, if `x509_ca_file` is defined:
  * all pkg installed jdk/jre will be modified to replace their cacerts file by
    a symlink to /etc/ssl/java/cacerts, which is created by Debian's certificates-java.jar
    using FreeBSD's CA database (including your CA)

A block is added in /root/post-install.sh to let you call it after pkg upgrade
(can also be run by cron)

Role Variables
--------------

  * `x509_ca_file` ('')
    source file for x509 AC certificate(s)
  * `x509_ca_path` (/etc/ssl/ca.crt)
    dest path for above cert file

Dependencies
------------

Example Playbook
----------------

    - hosts: servers
      roles:
         - { role: username.x509, x509_ca_file: files/myca.crt }

License
-------

BSD

Author Information
------------------

Yes another sysadmin
