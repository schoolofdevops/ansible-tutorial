# Chapter 4

## 4.1 Creating our first playbook
### 4.1.1 Playbook file
Change your current directory to chapter 4
Create a file edit playbook.yml  and put the following content

{title="Listing ", lang=html, linenos=off}
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

## 4.2 Running our playbook  
To implement the playbook, we need to run the following command  

{title="Listing ", lang=html, linenos=off}
~~~~~~~
ansible-playbook playbook.yml
~~~~~~~

This will give us the following output  
{title="Listing ", lang=html, linenos=off}
~~~~~~~
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

## 4.3 Adding second play in the playbook  
Add the following block of code in playbook.yml file and save it  

{title="Listing ", lang=html, linenos=off}
~~~~~~~
- name: App Server Configurations
  hosts: app
  become: true
  tasks:
    - name: create app user
      user: name=app state=present uid=5002

    - name: install git
      yum:  name=git  state=present

~~~~~~~  

Run the playbook again...  

{title="Listing ", lang=html, linenos=off}
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

## 4.4 Limiting the execution to particular group  

Now run the following command to restrict the playbook execution to *app servers*  

{title="Listing ", lang=html, linenos=off}
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
