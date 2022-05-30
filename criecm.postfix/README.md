Role Name
=========

Postfix role

Role Variables
--------------

* `postfix_config ({})`
  dict of postfix main.cf parameters
* `postfix_services ({})`
  dict of postfix master.cf services, key is "service/type" (smtp/inet), with:
    * `fields` as in postconf -F: needs at least "command" to be created
       other fields defaults to "-": `private`, `unprivileged`, `chroot`, `wakeup`, `process_limit`
    * `parameters` dict (postfix parameters to override main.cf's ones)

Example Playbook
----------------

    # simple relayhost config
    - hosts: servers
      roles:
         - { role: criecm.postfix, postfix_config:{relayhost: smtp.my.provider} }

    # mx with postscreen enabled and another port for our machines
    # (this is a sample you must not use as-is !)
    - hosts: mxservers
      roles:
        - criecm.postfix
      vars:
        postfix_config:
	  postscreen_access_list: 'permit_mynetworks,cidr:${config_directory}/postscreen_access.cidr,hash:${config_directory}/whitelist_clients'
	  mynetworks: "127.0.0.0/32,[::1]/128"
	postfix_services:
	  smtp/inet:
	    fields:
	      chroot: 'y'
	      process_limit: '1'
	      command: 'postscreen'
	  smtpd/pass:
	    fields:
	      chroot: 'y'
	      command: 'smtpd'
	  10025/inet:
	    fields:
	      chroot: 'y'
	      command: smtpd
	    parameters:
	      smtpd_recipient_restrictions: ''
	      mynetworks: "192.0.2.32/27,[2001:DB8:25:666::]/64,127.0.0.1/32,[::1]/128"


License
-------

BSD

Author Information
------------------

DSI Centrale Marseille
