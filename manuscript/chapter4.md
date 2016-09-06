# Chapter 4 : Learning to Write Playbooks

In this tutorial we are going to create a simple playbook to add system users, install and start ntp service and some basic utilities.


### 4.1 Creating our first playbook

  * Change working directory to /vagrant/code/chap4  
     ``` cd /vagrant/code/chap4 ```  
  * Create playbook.yml and add the content below

~~~~~~~
---
  - name: Base Configurations for ALL hosts
    hosts: all
    become: true
    tasks:
      - name: create admin user
        user: name=admin state=present uid=5001

      - name: remove dojo
        user: name=dojo  state=present

      - name: install tree
        yum:  name=tree  state=present

      - name: install ntp
        yum:  name=ntp   state=present

      - name: start ntp service
        service: name=ntpd state=started enabled=yes
~~~~~~~  

### 4.2 Running the  playbook  
To run the playbook, we are going to execute **ansible-playbook** command. Lets first examine the options that this command supports.

```
ansible-playbook --help

```

```
[output]

Usage: ansible-playbook playbook.yml

Options:
  --ask-become-pass     ask for privilege escalation password
  -k, --ask-pass        ask for connection password
  --ask-su-pass         ask for su password (deprecated, use become)
  -K, --ask-sudo-pass   ask for sudo password (deprecated, use become)
  --ask-vault-pass      ask for vault password
  -b, --become          run operations with become (nopasswd implied)
  --become-method=BECOME_METHOD
                        privilege escalation method to use (default=sudo),
                        valid choices: [ sudo | su | pbrun | pfexec | runas |
                        doas ]

.......
```

To run the playbook, we could call YAML file as an argument. Since we have already defined the inventory and configurations, additional options are not necessary at this time.

~~~~~~~
ansible-playbook playbook.yml
~~~~~~~

~~~~~~~
[output]

PLAY [Base Configurations for ALL hosts] ***************************************

TASK [setup] *******************************************************************
ok: [192.168.61.14]
ok: [192.168.61.11]
ok: [localhost]
ok: [192.168.61.12]
ok: [192.168.61.13]

TASK [create admin user] *******************************************************
changed: [192.168.61.13]
changed: [192.168.61.12]
changed: [localhost]
changed: [192.168.61.11]
changed: [192.168.61.14]

TASK [remove dojo] *************************************************************
changed: [192.168.61.14]
changed: [localhost]
changed: [192.168.61.12]
changed: [192.168.61.11]
changed: [192.168.61.13]

TASK [install tree] ************************************************************
ok: [localhost]
ok: [192.168.61.13]
ok: [192.168.61.12]
ok: [192.168.61.14]
ok: [192.168.61.11]

TASK [install ntp] *************************************************************
changed: [192.168.61.12]
changed: [192.168.61.13]
changed: [192.168.61.11]
changed: [localhost]
changed: [192.168.61.14]

TASK [start ntp service] *******************************************************
changed: [192.168.61.11]
changed: [localhost]
changed: [192.168.61.13]
changed: [192.168.61.12]
changed: [192.168.61.14]
~~~~~~~

### 4.3 Adding second play in the playbook  

Lets add a second play specific to app servers. Add the following block of code in playbook.yml file and save   

~~~~~~~
- name: App Server Configurations
  hosts: app
  become: true
  tasks:
    - name: create app user
      user: name=app state=present uid=5003

    - name: install git
      yum:  name=git  state=present

~~~~~~~  

Run the playbook again...  

~~~~~~~
ansible-playbook playbook.yml
~~~~~~~

~~~~~~~

PLAY [Base Configurations for ALL hosts] ***************************************

TASK [setup] *******************************************************************
ok: [localhost]
ok: [192.168.61.14]
ok: [192.168.61.13]
ok: [192.168.61.12]
ok: [192.168.61.11]

TASK [create admin user] *******************************************************
ok: [192.168.61.14]
ok: [localhost]
ok: [192.168.61.13]
ok: [192.168.61.12]
ok: [192.168.61.11]

TASK [remove dojo] *************************************************************
ok: [192.168.61.14]
ok: [192.168.61.12]
ok: [192.168.61.11]
ok: [localhost]
ok: [192.168.61.13]

TASK [install tree] ************************************************************
ok: [192.168.61.11]
ok: [192.168.61.12]
ok: [localhost]
ok: [192.168.61.13]
ok: [192.168.61.14]

TASK [install ntp] *************************************************************
ok: [192.168.61.12]
ok: [192.168.61.13]
ok: [192.168.61.14]
ok: [192.168.61.11]
ok: [localhost]

TASK [start ntp service] *******************************************************
ok: [192.168.61.13]
ok: [192.168.61.14]
ok: [localhost]
ok: [192.168.61.11]
ok: [192.168.61.12]

PLAY [App Server Configurations] ***********************************************

TASK [setup] *******************************************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [create app user] *********************************************************
changed: [192.168.61.12]
changed: [192.168.61.13]

TASK [install git] *************************************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

PLAY RECAP *********************************************************************
192.168.61.11              : ok=6    changed=0    unreachable=0    failed=0
192.168.61.12              : ok=9    changed=1    unreachable=0    failed=0
192.168.61.13              : ok=9    changed=1    unreachable=0    failed=0
192.168.61.14              : ok=6    changed=0    unreachable=0    failed=0
localhost                  : ok=6    changed=0    unreachable=0    failed=0
~~~~~~~

### 4.4 Limiting the execution to a particular group  

Now run the following command to restrict the playbook execution to *app servers*  

~~~~~~~
ansible-playbook playbook.yml --limit app
~~~~~~~

This will give us the following output, plays will be executed only on app servers...  

{title="Listing ", lang=html, linenos=off}
~~~~~~~

PLAY [Base Configurations for ALL hosts] ***************************************

TASK [setup] *******************************************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [create admin user] *******************************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [remove dojo] *************************************************************
ok: [192.168.61.12]
ok: [192.168.61.13]

TASK [install tree] ************************************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [install ntp] *************************************************************
ok: [192.168.61.12]
ok: [192.168.61.13]

TASK [start ntp service] *******************************************************
ok: [192.168.61.12]
ok: [192.168.61.13]

PLAY [App Server Configurations] ***********************************************

TASK [setup] *******************************************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [create app user] *********************************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [install git] *************************************************************
ok: [192.168.61.12]
ok: [192.168.61.13]

PLAY RECAP *********************************************************************
192.168.61.12              : ok=9    changed=0    unreachable=0    failed=0
192.168.61.13              : ok=9    changed=0    unreachable=0    failed=0

~~~~~~~

## Exercise:
Create a Playbook with the following specifications,
  * It should apply only on local host (ansible host)
  * Should use become method
  * Should create a **user** called webadmin with shell as "/bin/sh"
  * Should install and start **nginx** service
  * Should **deploy** a sample html app into the default web root directory of nginx using ansible's **git** module. Source repository for the app is at https://github.com/schoolofdevops/html-sample-app
