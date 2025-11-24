# nsd

Install & (re)configure nsd server on Debian, FreeBSD or OpenBSD
avec `nsd-control (add|delete)zone $ZONE $PATTERN`


## Variables (default)

* `nsd_addresses` ([])
  list of ip address (`*` if empty)
* `nsd_patterns` ([])
  list of patterns to use with zones
  item format: same as `pattern` in nsd.conf
* `nsd_keys` ([])
  list of TSIG keys
  item format: same as `key` in nsd.conf
* `nsd_zones` ([])
  list of zones to add/modify
  item format: dict with `name` and `pattern` elements (eventually 'intpattern' for machines with `is_internal_nsd` == True)
  * if `pattern` is not defined, zone will be skipped by hosts (unless host has `is_internal_nsd==True` and `intpattern` is defined)
  * if `pattern` (or `intpattern` if applicable) is defined but the pattern is not in `nsd_patterns`, zone is skipped by the host
  to create list from existing zones, type on your nsd server:
    `echo "    nsd_zones:"; nsd-control zonestatus | awk '/^zone:/ { z=$2; } /pattern:/ { printf("      - { name: '\''%s'\'', pattern: %s }\n",z,$2); }'`
* `is_internal_nsd` (False)
  prefer "intpattern" to "pattern" in `nsd_zones`
* `nsd_zones_force_pattern` ('')
  if not empty, use this pattern for *all* zones in `nsd_zones`
* `nsd_zonesdir_owner` (root)
  user who should own master zone files
