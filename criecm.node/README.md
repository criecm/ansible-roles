# criecm.node

Install/run node apps on FreeBSD (could be easily adapted)

## Features:
* dedicated system user/home
* git source pull/update
* config template placeholder
* syslog for output
* FreeBSD rc script for start/stop/restart

## Role Variables

* `node_version` (8)
  node major version
* `node_apps` ([])
  list of dicts for each app (see **app variables** below)
* `node_update_git` (True)
  update git sources if any
* `node_force_git` (False)
  update git sources overriding local changes
* `node_force_conf` (False)
  overwrite existing config files
* `node_start_app` (True)
  Set to false to start/enable app by other way

### app variables

* `name` MANDATORY
  short name for the app, [a-z0-9] only
* `user` (`name`)
* `path` (/home/`name`)
* `script` (app.js)
* `scriptargs ({})`
  dict of runtime flags passed to script
* `gitsrc` ('')
  Git repository source
* `gitversion ('master')`
  Git repo tag/branch
* `gitupdate` (`node_update_git`)
  Will update source code
* `gitforce` (`node_force_git`)
  Will force source update
* `confs` ([])
  List of config files, as dicts of {src=template,dest=dest}
  dest can be relative to `app.path`
* `use_syslog` (False)
  IP/name of syslog server (do enable syslog)
* `syslog_tag` (`app.name`)
* `env (developement)`
  NODE_ENV value
* `envvars ({})`
  dict of environment variables

## Dependencies

## Example Playbook

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - criecm.node
      vars:
        node_apps:
          - name: myapp1
            script: index.js
            gitsrc: 'https://git.web.url/myproject.git'
            confs:
              - src: mytemplace.js.j2
                dest: config.js

## License

BSD

