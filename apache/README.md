# Role pour install apache ET sites

types d'installation (`apache_type`):
  * backend: pas de https, configs copiees depuis `playbooks/files/apache/backend/*`
        (les noms des sous-repertoires dépendent de la distribution)
  * rproxy: idem depuis `playbooks/files/apache/rproxy/*`

* Installe apache avec les configs ci-dessus

* configure la rotation des logs

* pour chaque site dans `apache_sites`:
  * copie la conf (template) depuis le premier trouvé dans la liste `siteconf_locations`
    (voir vars/site.yml)

* pour chaque `include` de `site.includes` du site:
  * copie (template) le premier trouvé de la liste `include_location`
    (voir vars/site.yml)

* droits:
  * chown -R root par defaut
  * les fichiers listes dans grwfiles sont 'chown g+w'
  * les reps listes dans grwdirs sont 'chown -R g+w'
  * tout est 'chown -R root:groupe' (groupe vaut `apache_user` si non défini)
