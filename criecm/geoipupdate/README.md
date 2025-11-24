Role Name
=========

Update maxmind config for updates

Role Variables
--------------

* `maxminddb_id: ('')` maxmind ID
* `maxminddb_key: ('')` maxmind key
* `geoipeditions: (["GeoLite2-Country","GeoLite2-City","GeoLite2-ASN"])` list of needed files

Example Playbook
----------------

    - hosts: servers
      roles:
        - criecm.geoipupdate
      vars:
        maxminddb_id: myId
        maxminddb_key: myKey

License
-------

BSD

Author Information
------------------

https://dsi.centrale-med.fr/
