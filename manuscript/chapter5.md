# Chapter 5  

In this tutorial we are going to create simple, static role for apache which will,
  * Install **httpd** package
  * Configure **httpd.conf**, manage it as a static file
  * Start httpd service
  * Add a notification and a  handler so that whenever the configuration is updated, service is automatically restarted.

### 5.1 Creating Role Scaffolding  for Apache
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

To being with, in this part, we will install and start apache.

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

```
[Output]
PLAY [app] *********************************************************************

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


#### 5.3 Managing Configuration files for Apache

  * Create a task file to copy over configuration files. Create it  at  *roles/apache/tasks/config.yml*,   

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

#### 5.2.2 Files directory

Copy *index.html* and *httpd.conf* from `chap5` to */roles/apache/files/* directory  

#### 5.2.3 Meta directory
*roles/apache/meta/main.yml* this file, should contain...  

{title="Listing ", lang=html, linenos=off}
~~~~~~~
---
dependencies:
 - {role: base}
~~~~~~~  





#### 5.2.4 Handlers directory  
Put following content in *roles/apache/handlers/main.yml*  

{title="Listing ", lang=html, linenos=off}
~~~~~~~
---
- name: Restart apache service
  service: name=httpd state=restarted
~~~~~~~






  * Create *site.yml* in chap5 directory and put  

{title="Listing ", lang=html, linenos=off}
~~~~~~~
---
- include: app.yml
~~~~~~~




### 5.3 Testing our role...  
Now let's test the role that we have created...  
Create a file *app.yml* in `chap5` directory.
Edit *app.yml* file and make sure it **only** contains following content.  

{title="Listing ", lang=html, linenos=off}
~~~~~~~
---
- hosts: app
  become: true
  roles:
    - apache
~~~~~~~  


Then run the ansible-playbook command  
{title="Listing ", lang=html, linenos=off}
~~~~~~~
ansible-playbook playbook.yml
~~~~~~~  


The output will be,  

{title="Listing ", lang=html, linenos=off}
~~~~~~~
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
~~~~~~~



## 5.4 Exercises
1. Create roles for *db* and *loadbalancer* following the same workflow
=======
## 5.3 Exercises
1. Create roles for *db* and *lb* following the same workflow
>>>>>>> origin/master
