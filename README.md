# Ansible @ ECM

## Roles ansible Centrale Marseille:

Prévus pour Debian, FreeBSD, OpenBSD

Ansible >= 2.2.1.0

## Prérequis

[lire la doc](http://docs.ansible.com/ansible/intro_getting_started.html "getting started")

* un 'inventory' ([/usr/local]/etc/ansible/hosts, voir ~/.ansible.cfg ou [/usr/local]/etc/ansible/ansible.cfg)
* **une cle ssh** permettant de se connecter a chaque machine de l'inventory
    (en root ou en --ansible-user=\* avec --become=[sudo|su|pbrun|pfexec|runas|doas|dzdo])

## Usage

1. definir les variables necessaires (voir `<role>/defaults/main.yml` les variables disponibles)
2. ecrire un playbook qui utilise les roles voulus
3. lancer `ansible-playbook playbook-my.yml`

