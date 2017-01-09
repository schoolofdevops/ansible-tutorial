# Control Structures
In Chapter 7, we will learn about the aspects of conditionals and iterations that affects program's execution flow in Ansible  
Control structures are of two different type

* Conditional  
* Iterative  

## Conditionals  
Conditionals structures allow Ansible to choose an alternate path. Ansible does this by using *when* statements  

### **When** statements  
When statement becomes helpful, when you will want to skip a particular step on a particular host  

#### Selectively calling install tasks based on platform  
* Edit *roles/apache/tasks/main.yml*,

```
---
- include: install.yml
  when: ansible_os_family == 'RedHat'
- include: start.yml
- include: config.yml
```

* This will include *install.yml* only if the OS family is Redhat, otherwise it will skip the installation playbook  

#### Configuring MySQL server based on boolean flag  
* Edit *roles/mysql/tasks/main.yml* and add when statements,

```
---
# tasks file for mysql
- include: install.yml

- include: start.yml
  when: mysql.server

- include: config.yml
  when: mysql.server
```

* Edit *db.yml* as follows,

```
---
- name: Playbook to configure DB Servers
  hosts: db
  become: true
  roles:
  - mysql
  vars:
    mysql:
      server: true
      config:
        bind: "{{ ansible_eth0.ipv4.address }}"
```

#### Adding conditionals in Jinja2 templates  
* Put the following content in *roles/mysql/templates/my.cnf.j2*

```
[mysqld]

{% if mysql.config.datadir is defined %}
datadir={{ mysql['config']['datadir'] }}
{% endif %}

{% if mysql.config.socket is defined %}
socket={{ mysql['config']['socket'] }}
{% endif %}

symbolic-links=0
log-error=/var/log/mysqld.log

{% if mysql.config.pid is defined %}
pid-file={{ mysql['config']['pid']}}
{% endif %}

[client]
user=root
password={{ mysql_root_db_pass }}
```

* These conditions will run flawlessly, because we have already defined these Variables  

#### Running One Time Tasks  
* To see how this works, lets take a look at the code in *roles/mysql/tasks/config.yml*

```
    [...]
- name: reset default root password
shell: mysql --user=root --password="{{ MYSQL_DEFAULT_PASS }}" --connect-expired-password mysql < /root/.mysql_reset_pass.sql
run_once: true
ignore_errors: yes
     [...]
```

* In some cases there may be a need to only run a task one time and only on one host. This can be achieved by configuring “run_once” on a task

#### Conditional Execution of Roles  
* This will execute app playbook only if the node is running **RedHat** family
* Update app.yml to restrict role to be run only on RedHat platform.

```
---
  - name: Playbook to configure App Servers
    hosts: app
    become: true
    vars:
      fav:
        fruit: mango
    roles:
    - { role: apache, when: ansible_os_family == 'RedHat' }
```

* Let's run this code

```
ansible-playbook site.yml
```
[Output]

```
TASK [setup] *******************************************************************
ok: [192.168.61.12]
ok: [192.168.61.13]

TASK [base : create admin user] ************************************************
skipping: [192.168.61.12]
skipping: [192.168.61.13]

TASK [base : remove dojo] ******************************************************
skipping: [192.168.61.12]
skipping: [192.168.61.13]

TASK [base : install tree] *****************************************************
skipping: [192.168.61.12]
skipping: [192.168.61.13]

TASK [base : install ntp] ******************************************************
skipping: [192.168.61.12]
skipping: [192.168.61.13]

TASK [base : start ntp service] ************************************************
skipping: [192.168.61.12]
skipping: [192.168.61.13]

TASK [apache : Installing Apache...] *******************************************
skipping: [192.168.61.12]
skipping: [192.168.61.13]

TASK [apache : Starting Apache...] *********************************************
skipping: [192.168.61.12]
skipping: [192.168.61.13]

TASK [apache : Creating configuration from templates...] ***********************
skipping: [192.168.61.12]
skipping: [192.168.61.13]

TASK [apache : Copying index.html file...] *************************************
skipping: [192.168.61.12]
skipping: [192.168.61.13]

```

**Exercise**: Try using **Debian** instead of **RedHat** . You shall see app role being skipped altogether. Don't forget to put it back after you try this out.  
