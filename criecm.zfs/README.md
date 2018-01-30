# criecm.zfs

Setup ZFS on system

Create zfs filesystems / volumes
  * integrates with `criecm.samba`, `criecm.nfs_server` and `criecm.ctld`
  * replication (every hour by default)

## Requirements

Filer with zfs !

## Role Variables

  * `shares`: list of `share` dicts
  * `zfs_sync_vol` script if you need replication

### share variables
  * `zfsrc` (MANDATORY)
    ZFS source
  * `path` (MANDATORY for zfs filesystem)
    if defined, will set the mountpoint of a filesystem
  * `volsize` (MANDATORY for zfs volume)
    if defined, will create a volume instead of filesystem
  * `zfsprops` ({})
    dict of zfs properties to set

#### if you want replication, add:
  * `backup_on` ('')
    "zfs/path@host" to set up synchronization
  * `backup_minute` ({pseudo-random})
    minute field for crontab
    if you replicate many filesystems more than once per hour, take care of
    choosing different minutes to avoid launching all at the same time
  * `backup_hour` (`*`)
    hour field for crontab

## replication
  * [`zfs_sync_vol`](https://github.com/criecm/savscript/raw/master/lib/zfs_sync_vol) script for replication
    if not installed, the role will download it to /root/zfs_sync_vol on backup machine(s)
    (the role may be easily adapted to use another tool)

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: server
      roles:
        - criecm.zfs
      vars:
        shares:
          # simple zfs filesystem
          - zfsrc: zdata/my/files
            path: /shares/myfiles
          # simple zfs volume
          - zfsrc: zdata/volz/myvol1
            volsize: '25G'
          # more complex filesystem
          - zfsrc: zdata/my/filesystems
            zfsprops:
              atime: 'off'
              refquota: '5G'
              aclmode: passthrough
            # replicate to otherhost
            backup_to: otherhost
            # replicate 4 times per hour
            backup_minute: '14,28,42,56'
          # replicated volumes container
          - zfsrc: zdata/rvolz
            path: 'none'
            backup_to: otherhost
            # backup every 4 hour
            backup_hour: '*/4'
          # this volume will be replicated with above container
          - name: simple-repl-vol
            zfsrc: zdata/rvolz/mysecondvol
            volsize: '15G'
    
          # cifs (with shadow copy) & nfs shared, acl enabled, replicated fs
          # (you'll only need to list criecm.samba and/or criecm.nfs_server here, as
          #  both will `include_role: criecm.zfs`)
          - name: sales
            zfsrc: zdata/depts/sales
            zfsprops:
              aclmode: passthrough
              aclinherit: passthrough
            cifs: Yes
            smbparams:
              comment: 'Y: on shaun'
              write list: '@admin_dsi @prof'
              read only: 'No'
              vfs objects: zfsacl shadow_copy2
              nfs4:chown: 'yes'
              nfs4:acedup: 'merge'
              nfs4:mode: 'special'
              shadow:sort: desc
              shadow:format: 'GMT-%Y.%m.%d-%H.%M.%S'
              shadow:snapdir: .zfs/snapshot
              inherit acls: 'Yes'
              inherit owner: 'Yes'
              inherit permissions: 'Yes'
            nfsshares:
              - "-maproot=0 -network=192.0.2.0/24"
              - "-network=203.0.113.0/24"

## License

BSD

## Author Information

https://dsi.centrale-marseille.fr/
