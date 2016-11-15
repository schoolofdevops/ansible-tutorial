# Chapter 4 : Learning to Write Playbooks

In this tutorial we are going to create a simple playbook to add system users, install and start ntp service and some basic utilities.


### 4.1 Creating our first playbook

  * Change working directory to /vagrant/code/chap4  
```
     cd /vagrant/code/chap4
```  


  * Edit myhosts.ini if required and comment the hosts which are absent.

  * Add the following configuration to ansible.cfg.   

  ``` retry_files_save_path = /tmp ```

  This defines the path where retry files are created in case of failed ansible run. We will learn about this in later in this chapter.


  * Create a new file with name *playbook.yml* and add the following content to it

```
---
  - name: Base Configurations for ALL hosts
    hosts: all
    become: true
    tasks:
      - name: create admin user
        user: name=admin state=present uid=5001

      - name: remove dojo
        user: name=dojo  state=absent

      - name: install tree
        yum:  name=tree  state=present

      - name: install ntp
        yum:  name=ntp   state=present

```

### 4.2 Applying  playbook  
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

```
ansible-playbook playbook.yml
```

```
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

```

### 4.3 Adding a new task to the play , Troubleshooting


Add the following task to start ntp service to the same playbook. When you add this taks, make sure the indentation is correct.

```
      - name: start ntp service
        service: name=ntp state=started enabled=yes
```  

  * Apply playbook again, check the output


```
ansible-playbook playbook.yml

```

[output]
```
TASK [start ntp service] *******************************************************
fatal: [localhost]: FAILED! => {"changed": false, "failed": true, "msg": "no service or tool found for: ntp"}
fatal: [192.168.61.11]: FAILED! => {"changed": false, "failed": true, "msg": "no service or tool found for: ntp"}
fatal: [192.168.61.12]: FAILED! => {"changed": false, "failed": true, "msg": "no service or tool found for: ntp"}

NO MORE HOSTS LEFT *************************************************************
	to retry, use: --limit @/tmp/playbook.retry

PLAY RECAP *********************************************************************
192.168.61.11              : ok=5    changed=0    unreachable=0    failed=1
192.168.61.12              : ok=5    changed=0    unreachable=0    failed=1
localhost                  : ok=5    changed=0    unreachable=0    failed=1
```
Exercise : There was a intentional error introduced in the code. Identify the error from the log message above, correct it  and run the playbook again. This time you should run it  only on the failed hosts by limiting  with the retry file mentioned above (e.g. --limit @/tmp/playbook.retry )




### 4.4 Adding second play in the playbook  

Lets add a second play specific to app servers. Add the following block of code in playbook.yml file and save   

```
- name: App Server Configurations
  hosts: app
  become: true
  tasks:
    - name: create app user
      user: name=app state=present uid=5003

    - name: install git
      yum:  name=git  state=present

```  

Run the playbook again...  

```
ansible-playbook playbook.yml
```

```

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
```

### 4.5 Limiting the execution to a particular group  

Now run the following command to restrict the playbook execution to *app servers*  

```
ansible-playbook playbook.yml --limit app
```

This will give us the following output, plays will be executed only on app servers...  

```

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

```


## Exercise:
Exercise1: Create a Playbook with the following specifications,
  * It should apply only on local host (ansible host)
  * Should use become method
  * Should create a **user** called webadmin with shell as "/bin/sh"
  * Should install and start **nginx** service
  * Should **deploy** a sample html app into the default web root directory of nginx using ansible's **git** module.
    * Source repo:  https://github.com/schoolofdevops/html-sample-app
    * Deploy Path : /usr/share/nginx/html/app
  * Once deployed, validate the site by visting http://CONTROL_HOST_IP/app

Exercise 2: Disable Facts Gathering
  * Run ansible playbook and observe the output
  * Add the following configuration parameter to ansible.cfg
    ``` gathering = explicit ```
  * Launch ansible playbook run again, observe the output and compare it with the previous run.
