# Chapter 5  

In this tutorial we are going to create simple, static role for apache which will,
  * Install **httpd** package
  * Configure **httpd.conf**, manage it as a static file
  * Start httpd service
  * Add a notification and a  handler so that whenever the configuration is updated, service is automatically restarted.

### 5.1 Creating Role Scaffolding for Apache
  * Change working  directory to **/vagrant/code/chap5**

      ``` cd  /vagrant/code/chap5 ```

  * Create roles directory

       ``` mkdir roles ```

  * Generate role scaffolding using ansible-galaxy

       ``` ansible-galaxy init --offline --init-path=roles  apache ```

  * Validate

       ``` tree roles/ ```     

```
[Output]

  roles/
    └── apache
        ├── defaults
        │   └── main.yml
        ├── files
        ├── handlers
        │   └── main.yml
        ├── meta
        │   └── main.yml
        ├── README.md
        ├── tasks
        │   └── main.yml
        ├── templates
        ├── tests
        │   ├── inventory
        │   └── test.yml
        └── vars
            └── main.yml

```


### 5.2 Writing Tasks to Install and Start  Apache Web Service

We are going to create three different tasks files, one for each phase of application lifecycle
  * Install
  * Configure
  * Start Service

To begin with, in this part, we will install and start apache.

  *  To install apache, Create *roles/apache/tasks/install.yml*

~~~~~~~
---
- name: Install Apache...
  yum: name=httpd state=latest
~~~~~~~  


  * To start the service, create  *roles/apache/tasks/start.yml* with the following content  

~~~~~~~
---
- name: Starting Apache...
  service: name=httpd state=started
~~~~~~~  


To have these tasks being called, include them into main task.

  * Edit roles/apache/tasks/main.yml

```
---
# tasks file for apache
- include: install.yml
- include: start.yml
```

  * Create a playbook for app servers at /vagrant/chap5/app.yml with following contents

  ```
  ---
  - hosts: app
    become: true
    roles:
      - apache
  ```

  * Apply app.yml with ansible-playbook

  ```
  ansible-playbook app.yml
  ```

[Output]

```
PLAY [Playbook to configure App Servers] *********************************************************************

TASK [setup] *******************************************************************
ok: [192.168.61.12]
ok: [192.168.61.13]

TASK [apache : Install Apache...] **********************************************
changed: [192.168.61.13]
changed: [192.168.61.12]

TASK [apache : Starting Apache...] *********************************************
changed: [192.168.61.13]
changed: [192.168.61.12]

PLAY RECAP *********************************************************************
192.168.61.12              : ok=3    changed=2    unreachable=0    failed=0
192.168.61.13              : ok=3    changed=2    unreachable=0    failed=0
```


### 5.3 Managing Configuration files for Apache
  * Copy *index.html* and *httpd.conf* from *chap5/helper* to */roles/apache/files/* directory  

  * Create a task file at **roles/apache/tasks/config.yml** to manage files.    

~~~~~~~
---
- name: Copying configuration files...
  copy: src=httpd.conf
        dest=/etc/httpd.conf
        owner=root group=root mode=0644
  notify: Restart apache service

- name: Copying index.html file...
  copy: src=index.html
        dest=/var/www/html/index.html
        mode=0777
~~~~~~~  

### 5.4 Handlers directory  
  * Put following content in *roles/apache/handlers/main.yml*  

~~~~~~~
---
- name: Restart apache service
  service: name=httpd state=restarted
~~~~~~~  
[Output]  
```

PLAY [Playbook to configure App Servers] ***************************************

TASK [setup] *******************************************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [apache : Installing Apache...] *******************************************
ok: [192.168.61.12]
ok: [192.168.61.13]

TASK [apache : Starting Apache...] *********************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [apache : Copying configuration files...] *********************************
changed: [192.168.61.12]
changed: [192.168.61.13]

TASK [apache : Copying index.html file...] *************************************
changed: [192.168.61.12]
changed: [192.168.61.13]

RUNNING HANDLER [apache : Restart apache service] ******************************
changed: [192.168.61.12]
changed: [192.168.61.13]

PLAY RECAP *********************************************************************
192.168.61.12              : ok=6    changed=3    unreachable=0    failed=0
192.168.61.13              : ok=6    changed=3    unreachable=0    failed=0

```  

### 5.5  Test Apache Role
  * Now let's test the role that we have created...  
  * Create a file *app.yml* in `chap5` directory.
  * Edit *app.yml* file and make sure it **only** contains following content.  

~~~~~~~
---
- hosts: app
  become: true
  roles:
    - apache
~~~~~~~  
  * Run the playbook  
``` ansible-playbook app.yml ```   

[Output]  
```
PLAY [App server configurations] ***********************************************

TASK [setup] *******************************************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [apache : Installing Apache...] *******************************************
changed: [192.168.61.13]
changed: [192.168.61.12]

PLAY RECAP *********************************************************************
192.168.61.12              : ok=2    changed=1    unreachable=0    failed=0
192.168.61.13              : ok=2    changed=1    unreachable=0    failed=0
```

### 5.6 Add dependency to a role  
  * Create a base role with ansible-galaxy utility,  
``` ➜  base ansible-galaxy init --offline --init-path roles/ base ```  
  * Put the following content to */roles/base/tasks/main.yml*  
```
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

```  
  * Add base role dependency to apache role,  
  *roles/apache/meta/main.yml* this file, should contain...  

~~~~~~~
---
dependencies:
 - {role: base}
~~~~~~~  
  * Now check how dependency works,  
```
➜  chap6 ansible-playbook site.yml

PLAY [Playbook to configure App Servers] ***************************************

TASK [setup] *******************************************************************
ok: [192.168.61.12]
ok: [192.168.61.13]

TASK [base : create admin user] ************************************************
ok: [192.168.61.12]
ok: [192.168.61.13]

TASK [base : remove dojo] ******************************************************
ok: [192.168.61.12]
ok: [192.168.61.13]

TASK [base : install tree] *****************************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [base : install ntp] ******************************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [base : start ntp service] ************************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [apache : Installing Apache...] *******************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [apache : Starting Apache...] *********************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [apache : Copying configuration files...] *********************************
ok: [192.168.61.12]
ok: [192.168.61.13]

TASK [apache : Copying index.html file...] *************************************
ok: [192.168.61.12]
ok: [192.168.61.13]

PLAY RECAP *********************************************************************
192.168.61.12              : ok=10   changed=0    unreachable=0    failed=0
192.168.61.13              : ok=10   changed=0    unreachable=0    failed=0
```


### 5.7 Exercises
1. Create scaffolding for **mariadb** role and **haproxy**
2. Install *mariadb* and *haproxy* in respective nodes
3. Make *haproxy* role dependent on *base* role
4. Create *db* and *lb* playbooks and make them available in **site wide playbook**
