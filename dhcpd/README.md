# dhcpd

Serveur isc-dhcpd, config manuelle dans dhcpd.conf.local

## Role variables

  * `dhcpd_default_domain`: '{{ ansible_domain }}'
    default domain name for dhcp clients
  * `dhcpd_default_dns`: '{{ resolvers[0].ip }}'
    resolver for clients
  * `dhcpd_default_lease_time`: 1200
  * `dhcpd_max_lease_time`: 7200
  * `dhcpd_enabled`: (True)
    may be used to install/configure dhcpd but not start it
  * `dhcpd_log_facility`: local7
    Syslog facility to use between dhcpd and syslogd
  * `syslog_server`: False
    Will send dhcpd logs there if not empty

