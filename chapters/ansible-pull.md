ansible-pull -U  https://github.com/schoolofdevops/ansible-repo -i myhosts.ini

  * Connects to git and checks out the repo
  * Finds fqdn.yml or local.yml  
  * Launches the playbook run


ansible-pull can
  *   -C CHECKOUT, --checkout=CHECKOUT   Accept the git branch/tag/commit to Pull
  *   -o, --only-if-changed




```
  ansible-pull -U  https://github.com/schoolofdevops/ansible-repo -i myhosts.ini
Starting Ansible Pull at 2016-11-15 14:54:53
/usr/bin/ansible-pull -U https://github.com/schoolofdevops/ansible-repo -i myhosts.ini
localhost | SUCCESS => {
    "after": "f93d954e4bdc3aebbe4fba690ceccf1f8285e508",
    "before": "f93d954e4bdc3aebbe4fba690ceccf1f8285e508",
    "changed": false,
    "warnings": [
        "Your git version is too old to fully support the depth argument. Falling back to full checkouts."
    ]
}
 [WARNING]: Your git version is too old to fully support the depth argument. Falling
back to full checkouts.

PLAY [Base Configurations for ALL hosts] ***************************************

TASK [setup] *******************************************************************
ok: [localhost]

TASK [create admin user] *******************************************************
ok: [localhost]

TASK [remove dojo] *************************************************************
ok: [localhost]

TASK [install tree] ************************************************************
ok: [localhost]

TASK [install ntp] *************************************************************
ok: [localhost]

TASK [start ntp service] *******************************************************
ok: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=0    unreachable=0    failed=0
ansible-pull -U  https://github.com/schoolofdevops/ansible-repo -i myhosts.ini
Starting Ansible Pull at 2016-11-15 14:54:53
/usr/bin/ansible-pull -U https://github.com/schoolofdevops/ansible-repo -i myhosts.ini
localhost | SUCCESS => {
    "after": "f93d954e4bdc3aebbe4fba690ceccf1f8285e508",
    "before": "f93d954e4bdc3aebbe4fba690ceccf1f8285e508",
    "changed": false,
    "warnings": [
        "Your git version is too old to fully support the depth argument. Falling back to full checkouts."
    ]
}
 [WARNING]: Your git version is too old to fully support the depth argument. Falling
back to full checkouts.

PLAY [Base Configurations for ALL hosts] ***************************************

TASK [setup] *******************************************************************
ok: [localhost]

TASK [create admin user] *******************************************************
ok: [localhost]

TASK [remove dojo] *************************************************************
ok: [localhost]

TASK [install tree] ************************************************************
ok: [localhost]

TASK [install ntp] *************************************************************
ok: [localhost]

TASK [start ntp service] *******************************************************
ok: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=0    unreachable=0    failed=0
```
