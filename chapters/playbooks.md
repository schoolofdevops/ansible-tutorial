# Learning to Write Playbooks

In this tutorial we are going to create a simple playbook to add system users, install and start ntp service and some basic utilities.

## Anatomy of a Playbook

## YAML - The Language to write Playbooks


## Writing and executing our first Playbook

**Problem Statement**  

You have to create a playbook which will  
  * create a admin user with uid 5001
  * remove  user dojo
  * install tree  utility
  * install ntp

on all systems which belong to  prod group in the inventory

To create playbook,

  * Change working directory to /vagrant/code/chap5  


```
cd /vagrant/code/chap5
```



  * Edit myhosts.ini if required and comment the hosts which are absent.

  * Add the following configuration to ansible.cfg.   

```
retry_files_save_path = /tmp
```

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

### Validating Syntax

Option 1 : Using --syntax-check option with ansible-playbook

```
ansible-playbook playbook.yml --syntax-check
```


**Exercise:**   Break the syntax, run playbook with --syntax check again, and learn how it works.

Option 2 : Using YAML Linter Online

Another way to validate syntax

  * Visit http://www.yamllinter.com
    ![YAML Linter](../images/ansible/yaml_lint.png)



### Using ansible-playbook utility
We will start using ansible-playbook utility to execute playbooks.

To learn how to use ansible-playbook execute the following command,

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

#### Dry Run

To execute ansible in a check mode, which will simulate tasks on the remote nodes, without actually committing, ansible provides --check or -C option. This can be invoked as ,

```
ansible-playbook playbook.yml --check

```

or
```
ansible-playbook playbook.yml -C
```

### Listing Hosts, Tasks and Tags in a Playbook

```
ansible-playbook playbook.yml --list-hosts

ansible-playbook playbook.yml --list-tasks

ansible-playbook playbook.yml --list-tags
```

### Executing Actions with Playbooks  

To execute  the playbook, we are going to execute **ansible-playbook** comman with playbook  YAML file as an argument. Since we have already defined the inventory and configurations, additional options are not necessary at this time.

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

## Error Handling and Debugging


We are now going to add a new task to the playbook that we created. This task would start ntp service on all prod hosts.

When you add this task, make sure the indentation is correct.

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

### Debugging Technique : Step By Step Execution

Ansible provides a way to execute tasks step by step, asking you whether to run or skip each task. This can be useful while debugging issues.

```
ansible-playbook playbook.yml --step
```

[Output]

```
root@control:/workspace/chap5# ansible-playbook playbook.yml --step                             

PLAY [Base Configurations for ALL hosts] ***************************************                
Perform task: TASK: setup (N)o/(y)es/(c)ontinue: y                                              


TASK [setup] *******************************************************************                
y                                                                                               
ok: [app1]                                                                                      
ok: [db]                                                                                        
ok: [app2]                                                                                      
ok: [lb]                                                                                        
Perform task: TASK: create admin user (N)o/(y)es/(c)ontinue:                                    

TASK [create admin user] *******************************************************                
yok: [app2]                                                                                     
ok: [app1]                                                                                      
ok: [db]                                                                                        
ok: [lb]                                                                                        

Perform task: TASK: install tree (N)o/(y)es/(c)ontinue: y                                       

TASK [install tree] ************************************************************                
ok: [app2]                                                                                      
ok: [lb]                                                                                        
ok: [app1]                                                                                      
ok: [db]                                                  
```


### Adding Additional  Play

Problem Statement:

You have to a new play to existing playbook  which will

  * create a app user with uid 5003
  * install git
  * on all app servers in the inventory

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
.......

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

### Limiting the execution to a particular group  

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

.........

TASK [start ntp service] *******************************************************
ok: [192.168.61.12]
ok: [192.168.61.13]

PLAY [App Server Configurations] ***********************************************

........

TASK [install git] *************************************************************
ok: [192.168.61.12]
ok: [192.168.61.13]

PLAY RECAP *********************************************************************
192.168.61.12              : ok=9    changed=0    unreachable=0    failed=0
192.168.61.13              : ok=9    changed=0    unreachable=0    failed=0

```


## Exercise:

### **Exercise1**: Create a Playbook with the following specifications,  

  * It should apply only on local host (ansible host)
  * Should use become method
  * Should create a **user** called webadmin with shell as "/bin/sh"
  * Should install and start **nginx** service
  * Should **deploy** a sample html app into the default web root directory of nginx using ansible's **git** module.
    * Source repo:  https://github.com/schoolofdevops/html-sample-app
    * Deploy Path : /usr/share/nginx/html/app
 * Once deployed, validate the site by visting http://CONTROL_HOST_IP/app

### **Exercise 2**: Disable Facts Gathering  

  * Run ansible playbook and observe the output
  * Add the following configuration parameter to ansible.cfg

```
gathering = explicit
```

  * Launch ansible playbook run again, observe the output and compare it with the previous run.
