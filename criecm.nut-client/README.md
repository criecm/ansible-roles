# criecm.nut-client

configure nut client

# Role Variables

* `nut_monitor ('')`
  The upsmon MONITOR line
# `nut_mode ("netclient")`
  NUT mode

# Example Playbook

    - hosts: servers
      roles:
         - { role: criecm.nut-client, nut_monitor: 'myups@nut.server 1 upsuser "upsuser_pass" primary' }

# License

BSD
