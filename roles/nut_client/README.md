# criecm.nut_client

configure nut client

# Role Variables

* `nut_monitor ('')`
  The upsmon MONITOR line
# `nut_mode ("netclient")`
  NUT mode

# Example Playbook

    - hosts: servers
      roles:
         - { role: criecm.nut_client, nut_monitor: 'myups@nut.server 1 upsuser "upsuser_pass" primary' }

# License

BSD
