# Chapter 5  : Working with Roles

In this tutorial we are going to create simple, static role for apache which will,
  * Install **httpd** package
  * Configure **httpd.conf**, manage it as a static file
  * Start httpd service
  * Add a notification and a  handler so that whenever the configuration is updated, service is automatically restarted.

### 5.1 Creating Role Scaffolding for Apache  
  * Change working  directory to **/vagrant/code/chap5**

```
cd  /vagrant/code/chap5
```

  * Create roles directory

```
mkdir roles
```

  * Generate role scaffolding using ansible-galaxy

```
ansible-galaxy init --offline --init-path=roles  apache
```

  * Validate

```
tree roles/
```

[Output]

```
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

  *  To install apache, Create **roles/apache/tasks/install.yml**

```
---
- name: Install Apache...
  yum: name=httpd state=latest
```  


  * To start the service, create  **roles/apache/tasks/start.yml** with the following content  

```
---
- name: Starting Apache...
  service: name=httpd state=started
```  


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
  * Copy **index.html** and **httpd.conf** from **chap5/helper** to **/roles/apache/files/** directory    

```
    cp helper/index.html helper/httpd.conf roles/apache/files/  
```  

  * Create a task file at **roles/apache/tasks/config.yml** to manage files.    

```
---
- name: Copying configuration files...
  copy: src=httpd.conf
        dest=/etc/httpd.conf
        owner=root group=root mode=0644

- name: Copying index.html file...
  copy: src=index.html
        dest=/var/www/html/index.html
        mode=0777
```  

#### 5.3.2 Adding Notifications and Handlers   

  * Previously we have create a task in roles/apache/tasks/config.yml to copy over httpd.conf to the app server. Update this file to send a notification to restart  service on configuration update.  You simply have to add the line which starts with **notify**

```
  - name: Copying configuration files...
    copy: src=httpd.conf
          dest=/etc/httpd.conf
          owner=root group=root mode=0644
    notify: Restart apache service
```

  * Create the notification handler by updating   **roles/apache/handlers/main.yml**  

```
---
- name: Restart apache service
  service: name=httpd state=restarted
```  

```
  ansible-playbook app.yml
```   


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

## Troubleshooting Exercise

Did the above command added the configuration files and restarted the service ? But we have already written **config.yml**. Troubleshoot why its not being run and fix it before you proceed.


### 5.4 Base Role and Role Nesting

  * Create a base role with ansible-galaxy utility,  
```
  ansible-galaxy init --offline --init-path=roles base
```  

  * Create tasks for base role by editing  **/roles/base/tasks/main.yml**  

```
---
# tasks file for base
# file: roles/base/tasks/main.yml
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

  * Define base role as a dependency for  apache role,  
  * Update meta data for Apache by editing **roles/apache/meta/main.yml** and adding the following
```
---
dependencies:
 - {role: base}
```  




### 5.5  Creating a Site Wide Playbook

We will create a site wide playbook, which will call all the plays required to configure the complete infrastructure. Currently we have a single  playbook for App Servers. However, in future we would create many.

  * Create **site.yml** in /vagrant/chap5 directory and add the following content

```
  ---
  # This is a sitewide playbook
  # filename: site.yml
  - include: app.yml

```  



  * Execute sitewide playbook as


```
ansible-playbook site.yml
```

[Output]

```

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


## Exercises

##### Exercise 1: Update Apache Configurations
  * Update httpd.conf and change some configuration parameters. Validate the service restarts on configuration updates by applying the sitewide playbook.


##### Exercise 2: Create MySQL Role
  * Create a Role to install and configure MySQL server   
     *    Create role scaffold for mysql  using ansible-galaxy init  
     *   Create task to install "mysql-server" and "MySQL-python" packages using yum module   
     *    Create a task to start mysqld service   
     *   Manage my.cnf by creating a centralized copy in role and writing a task to copy it to all db hosts. Use helper/my.cnf as a reference. The destination for this file is /etv/my.cnf on db servers.
     *    Write a handler to restart the service on configuration change. Add a notification from the copy resource created earlier.
     * Add a dependency on base role in the metadata for mysql role.  
     *     Create  **db.yml** playbook for configuring all database servers. Create definitions to configure **db** group and to apply **mysql** role.   
