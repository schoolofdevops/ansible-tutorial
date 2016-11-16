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

Stuff
 - dry run
   creating passwords : mkpasswd --method=sha-512
  - assert: { that: "ansible_os_family != 'RedHat'" }
  - jinja2 filters
  - expect

Playbook
  * disable fact finding to improve performance  ( gathering = implicit )
   When to disable facts caching ?



Additional Topics

  * Ansible Vault
  * Running Ansible Programatically : k
  * Windows Integration : k
  * Ansible and Docker : k
  * Ansible Pull: k
  * Registered variable examples: done
  * Ansible Tower: k

Chap 5 deprecated
* Pre Task to be run before creating MySQL Role

From Ansible Control node run the following command to enable repositories. This is needed in order to install some of the db packages.

```

  ansible db -s -a "cp -r /etc/yum.repos.d/repo.bkp/* /etc/yum.repos.d/"

```
