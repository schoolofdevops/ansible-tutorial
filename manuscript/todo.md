Additional chapters
  * Ansible Vault
  * Tags etc.
  * Managing Multiple Environments
  * Dynamic inventory
  * Ansible Tower
  * Ansible with Rundeck
  * Ansible with Docker
  * Ansible and windows

Chap3:
  *  add group of groups for inventory [blr:children]
  *  windows inventory example
  *  add host patterns, and filters
  *  more examples on modules
  *  ansible-doc -l to list modules available

chap4:
  * Error handling in playbooks

chap5:
  * Add a exercise to download/install a role from galaxy and apply

Playbook
  * disable fact finding to improve performance  ( gathering = implicit )
   When to disable facts caching ?



Additional Topics

  * Running Ansible Programatically
  * Windows Integration
  * Ansible and Docker
  * Ansible Pull

  * Registered variable examples

Chap 5 deprecated
* Pre Task to be run before creating MySQL Role

From Ansible Control node run the following command to enable repositories. This is needed in order to install some of the db packages.

```

  ansible db -s -a "cp -r /etc/yum.repos.d/repo.bkp/* /etc/yum.repos.d/"

```
