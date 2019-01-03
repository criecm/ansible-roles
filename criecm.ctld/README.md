# criecm.ctld

* Creates ZFS volumes for defined targets (if they are in /dev/zvol AND volsuze is defined)

* Configure ctl daemon (kernel-mode iscsi target)

You may read https://www.freebsd.org/doc/handbook/network-iscsi.html

## TODOs

* auth (only no-auth one network for now)

## Requirements

Some `/dev/*` to share on a FreeBSD system :)

## Role Variables (default value)

### MUST (no default)

* `iscsi_network_cidr` ('')
  Your iscsi network (eg: 192.168.623.0/34)
* `iscsi_targets` ([{}])
  list of ISCSI targets to configure, see [#Targets and Luns]

### SHOULD (You may prefer fix these):

* `iscsi_listen_ip` (will take the 1st foud that match `iscsi_network_cidr`)
  IP your target will listen to — by host
* `iscsi_domain` (`ansible_domain`)
  You may prefer fix this domain name for all hosts (used for iqn generation), 
  as your machines may have different fqdn domains…

### MAY (Facultatives)

* `iscsi_auth_group` ('defauthgroup')
  auth-group name
* `iscsi_portal_group` ('defportal')
  auth-portal name
* `iscsi_iqn_base` ('iqn.2017-12')
  first part of generated iqn
* `iscsi_iqn` (generated from `iscsi_iqn_base`, `iscsi_domain` and `ansible_hostname`)
  Another way to fix all iqns: write it yourself for each node in inventory

### Targets and Luns

```yaml
iscsi_targets:
  targetone:
    opts:
      alias: mytarget
    luns:
      0:
        devid: first
        path: /dev/zvol/zdata/iscsi/my_zfs_volume1
      1:
        devid: second
        path: /dev/zvol/zdata/iscsi/my_zfs_volume2
        opts: 
          option vendor: FreeBSDoption product: ZSan }
          option product: "zSan"
          option revision: 0002
        volsize: 143G
  targettwo:
    luns:
      0:
        devid: thirdlun
	path: /dev/hast0
```

#### target MUST contain

* `id` (`inventory_hostname`)
  target name - you must assign a different name to each target
* `opts` (`{}`)
  target-level parameters for [ctl.conf](https://www.freebsd.org/cgi/man.cgi?query=ctl.conf&sektion=5&manpath=freebsd-release-ports)

#### target MAY contain
* `iqn` (`scsi_iqn`)

#### target SHOULD contain Luns

* `luns` (`[{}]`)
  lun key is the lun numerical id.
  * `path` ('')
    path to the real device

each lun MAY contain any options that will be added to ctl.conf
  see [ctl.conf](https://www.freebsd.org/cgi/man.cgi?query=ctl.conf&sektion=5&manpath=freebsd-release-ports)
  
```yaml
iscsi_targets:
  - id: myfirstarget
    opts: { auth-group: "myauth", auth-portal: "myowntoo", alias: "myself"
    luns:
    

## Dependencies

Freebsd base system contains ctl daemon :)

## Example Playbook

```yaml
- hosts: targethost
  roles:
    - { role: criecm.ctld, iscsi_network_cidr: '10.0.1.0/24', iscsi_listen_ip: '10.0.1.1' }
  vars:
    iscsi_targets:
      myfirstarget:
        opts:
          alias: myfirst
        luns:
          0:
            path: /dev/myblockdevice
          1:
            path: /dev/anotherone
```

## License

BSD

## Author Information

Geoffroy Desvernay - CRI Centrale Marseille
