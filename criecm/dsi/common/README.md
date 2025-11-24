# common - base system role

* preferred shell pour root + it's config + aliases
* packages supplementaires (variable `pkgs`)

## templates and files

* vimrc file in files/ will be installed as /root/.vimrc

## Variables

  * `is_resolver` (False)
    if True, will use 127.0.0.1 in resolv.conf first
  * `resolvers ( [] )`
    list of dicts, ip will be used if host match network (in listed order)
    eg: `[{network='192.0.2.0/24',ip='192.0.2.53'},{network='2001:DB8::/32',ip='2001:DB8::53'}]`
  * `default_resolver_ipv4 ( ['208.67.222.222','8.8.4.4'] )`
    will be user if no match is found in `resolvers` and jail has IPv4
  * `default_resolver_ipv6 ( ['2620:119:35::35','2001:4860:4860::8844'] )`
    will be user if no match is found in `resolvers` and jail has IPv6
  * `dns64_resolvers ([])`
    for IP6-only hosts, overrides `resolvers` mechanism with DNS64-enabled resolvers
  * `ocsinventory_server` ('')
    If present, install and configure openinventory-agent
  * `root_shell` (zsh)
    Set your preferred one here :) (or set it empty to skip all this)
    put your rc file in {{ playbook_dir }}/files/{{ root_shell }}rc
  * `backup_dir (files/backups/{{ inventory_hostname }})`
    copy/restore /root/ files from here if any
  * `http_proxy ('')`
    To set http_proxy and https_proxy global values (FreeBSD only)

### FreeBSD specific

  * `pkg_repo_conf` (pkgecm.conf)
    name of a pkg repo config file to be installed first
  * `is_jail` (False)
    if True, will skip hardware monitoring tools (ipmi, dmidecode)
  * `freebsd_base_pkgs ([git,rsync,vim-console,root_shell])`
    list of packages to install

### OpenBSD specific

  * `openbsd_base_pkgs ([git,rsync,vim--no_x11,root_shell])`
    list of packages to install
  * `openbsd_pkg_mirror ("http://ftp.openbsd.org")`
    mirror to use

## Debian specific

  * `debian_base_pkgs (git,rsync,vim,root_shell])`
    list of packages to install
  * `debian_locales (fr_FR.UTF-8,en_US.UTF-8)`
    list of locales to enable

### Packages

  * `pkgs` ([])
    additionnal packages to install using distribution's package system
  * `host_pkgs` `role_pkgs` ([])
    other packages defined in inventory or roles (or whatever)
