# nsd

Install & (re)configure nsd server on Debian or FreeBSD
avec `nsd-control (add|delete)zone $ZONE $PATTERN`

## Variables (default)

* `nsd_patterns` ([])
  list of patterns to use with zones
  item format: same as `pattern` in nsd.conf
* `nsd_keys` ([])
  list of TSIG keys
  item format: same as `key` in nsd.conf
* `nsd_zones` ([])
  list of zones to add/modify
  item format: dict with `name` and `pattern` elements
  to create list from existing zones, type on your nsd server:
    `echo "    nsd_zones:"; nsd-control zonestatus | awk '/^zone:/ { z=$2; } /pattern:/ { printf("      - { name: '\''%s'\'', pattern: %s }\n",z,$2); }'`

