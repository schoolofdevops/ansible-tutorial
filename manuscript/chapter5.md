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

- name: Copying index.html file...
  copy: src=index.html
        dest=/var/www/html/index.html
        mode=0777
~~~~~~~  

#### 5.3.2 Adding Notifications and Handlers   

  * Update resource which copies **httpd.conf**  to sent a notification to restart  service.

```
  - name: Copying configuration files...
    copy: src=httpd.conf
          dest=/etc/httpd.conf
          owner=root group=root mode=0644
    notify: Restart apache service
```

  * Create the notification handler by updating   **roles/apache/handlers/main.yml**  

~~~~~~~
---
- name: Restart apache service
  service: name=httpd state=restarted
~~~~~~~  

``` ansible-playbook app.yml ```   


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



### 5.4 Base Role and Role Nesting

  * Create a base role with ansible-galaxy utility,  
``` ansible-galaxy init --offline --init-path=roles base ```  

  * Create tasks for base role by editing  **/roles/base/tasks/main.yml**  

```
---
# tasks file for base
# file: roles/base/tasks/main.yml
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
  * Update meta data for Apache by editing **roles/apache/meta/main.yml** and adding the following
~~~~~~~
---
dependencies:
 - {role: base}
~~~~~~~  




### 5.5  Creating a Site Wide Playbook

We will create a site wide playbook, which will call all the plays required to configure the complete infrastructure. Currently we have a single  playbook for App Servers. However, in future we would create many.

    * Create **site.yml** in `/vagrant/chap5` directory and add the following content

  ~~~~~~~
  ---
  - hosts: app
    become: true
    roles:
      - apache
  ~~~~~~~  
    * Run the playbook  




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
2. Make *haproxy* role dependent on *base* role
3. Create *db* and *lb* playbooks and make them available in **site wide playbook**  
4. Install *mariadb* and *haproxy* in respective nodes
