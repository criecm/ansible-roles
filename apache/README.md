# Role pour install apache ET sites

Deux types d'installation (`apache_type`):
  * backend: pas de https, configs copiees depuis `playbooks/files/apache_backend/*`
        (les noms des sous-repertoires dépendent de la distribution)
  * rproxy: TODO

* Installe apache avec les configs ci-dessus

* pour chaque site dans `apache_sites`:
  * copie la conf depuis (premier trouvé)
    * `playbooks/templates/apache/{{ site.key }}.conf.j2`
    * `playbooks/files/apache/{{ site.key }}.conf`
    * `playbooks/templates/apache/site.conf.j2`
    * `templates/site.conf.j2`
* pour chaque `include` de `site.includes` du site:
  * copie (template) le premier trouvé de la liste:
    * `playbooks/templates/apache/{{ site.key }}/{{ include }}.j2`
    * `playbooks/files/apache/{{ site.key }}/{{ include }}`
    * `playbooks/templates/apache/{{ include }}.j2`
    * `playbooks/files/apache/{{ include }}`


