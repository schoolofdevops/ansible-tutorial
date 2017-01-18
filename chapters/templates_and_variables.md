# Templates and Variables

In this  tutorial, we  are going to make the roles that we created earlier dynamically by adding templates and defining variables.

## Variables

Variables are of two types

* Automatic Variables/ Facts
* User Defined Variables

Lets try to discover information about our systems by using facts.

### Finding Facts About Systems

* Run the following command to see to facts of db servers  
```
ansible db -m setup
```

[Output]

```
192.168.61.11 | SUCCESS => {
        "ansible_facts": {
            "ansible_all_ipv4_addresses": [
                "10.0.2.15",
                "192.168.61.11"
            ],
            "ansible_all_ipv6_addresses": [
                "fe80::a00:27ff:fe30:3251",
                "fe80::a00:27ff:fe8e:83e0"
.....
                "tz_offset": "+0100",
                "weekday": "Monday",
                "weekday_number": "1",
                "weeknumber": "36",
                "year": "2016"
            }
```

### Filtering facts

* Use filter attribute to extract specific data

```
ansible db -m setup -a "filter=ansible_distribution"
```

[Output]

```
192.168.61.11 | SUCCESS => {
  "ansible_facts": {
      "ansible_distribution": "CentOS"
  },
  "changed": false
}  
```

## Creating Templates for Apache

* Create template for apache configuration    
* This template will change **port number**, **document root** and **index.html** for  apache server    
* Copy **httpd.conf** file from **roles/apache/files/** to **roles/apache/templates**    

```
cp roles/apache/files/httpd.conf roles/apache/templates/httpd.conf.j2
```

* Change your working directory to templates

```
cd roles/apache/templates
```

* Change values of following  parameters by using template variables in **httpd.conf.j2**  
  * Listen
  * DocumentRoot
  * DirectoryIndex

Following code depicts only the parameters changed. Rest of the configurations in *httpd.conf.j2* remain as is

```
Listen {{ apache_port }}
DocumentRoot "{{ custom_root }}"
DirectoryIndex {{ apache_index }} index.html.var
```

* Create a template for index.html as well

```
cp roles/apache/files/index.html roles/apache/templates/index.html.j2
```

* Add the following contents to index.html.j2

```
<html>
<body>
  <h1>  Welcome to Ansible training! </h1>

  <h2> SYSTEM INFO </h2>
  <h4>  ========================= </h4>
  <h3> Operating System : {{ ansible_distribution }} </h3>
  <h3> IP Address : {{ ansible_eth0['ipv4']['address'] }} </h3>

  <h2>  My Favourites </h2>
  <h4>  ========================= </h4>

  <h3> color     : {{ fav['color'] }} </h3>
  <h3> fruit     : {{ fav['fruit']   }} </h3>
  <h3> car       : {{ fav['car']   }} </h3>
  <h3> laptop    : {{ fav['laptop']   }} </h3>
  <h4>  ========================= </h4>

</body>
</html>

```

### Defining Default Variables

* Define values of the variables used in the templates above.  The default values are defined in *roles/apache/defaults/main.yml* . Lets edit that file and add the following,

```
apache_port: 80
custom_root: /var/www/html
apache_index: index.html
fav:
  color: white
  car: fiat
  laptop: dell
  fruit: apple
```

### Updating Tasks to use Templates

* Since we are now using template instead of static file, we need to edit *roles/apache/tasks/config.yml* file and use template module
* Replace **copy** module with **template** modules as follows,

```
---
- name: Creating configuration from templates...
  template: >
    src=httpd.conf.j2
    dest=/etc/httpd.conf
    owner=root
    group=root
    mode=0644
  notify: Restart apache service

- name: Copying index.html file...
  template: >
    src=index.html.j2
    dest=/var/www/html/index.html
    mode=0777

```

* Delete httpd.conf and index.html in files directory

```
  rm roles/apache/files/httpd.conf
  rm roles/apache/files/index.html
```

### Validating

* Let's test this template in action

```
ansible-playbook app.yml
```

[Output]

```
PLAY [Playbook to configure App Servers] ***************************************

TASK [setup] *******************************************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

.....

RUNNING HANDLER [apache : Restart apache service] ******************************
changed: [192.168.61.12]
changed: [192.168.61.13]

PLAY RECAP *********************************************************************
192.168.61.12              : ok=11   changed=3    unreachable=0    failed=0
192.168.61.13              : ok=11   changed=3    unreachable=0    failed=0
```

## Variable Precedence in Action

Lets define the variables from couple of other places, to learn about the Precedence rules. We will create,
* group_vars
* playbook vars

Since we are going to define the variables using multi level hashes, lets define the way hashes behave when defined from multiple places.

Update chap7/ansible.cfg and add the following,

```
hash_behaviour=merge
```

Lets create group_vars and create a group **prod** to define vars common to all prod hosts.

```
cd chap7
mkdir group_vars
cd group_vars
touch prod.yml
```

Edit **group_vars/prod.yml** file and add the following contents,

```
---
  fav:
    color: blue
    fruit: peach
```

Lets also add vars to playbook. Edit app.yml and add vars as below,

```
---
  - name: Playbook to configure App Servers
    hosts: app
    become: true
    vars:
      fav:
        fruit: mango
    roles:
    - apache
```

Execute the playbook and check the output

```
ansible-playbook app.yml
```

If you view the content of the html file generated, you would notice the following,

```
<h3> color     : blue </h3>
<h3> fruit     : mango </h3>
<h3> car       : fiat </h3>
<h3> laptop    : dell </h3>
```


| fav item | role defaults     | group_vars     | playbook_vars |
| :------------- | :------------- | :------------- | :------------- |
| color | white | **blue** |   |
| fruit | fiat      |  peach     | **mango** |
| car | **fiat**       |        |  |
| laptop | **apple**       |        |  |

* value of color comes from group_vars/all.yml
* value of fruit comes from playbook vars
* value of car and laptop comes from role defaults

## Registered  Variables

Lets create a playbook to run a shell command, register the result and display the value of registered variable.

Create **register.yml** in chap6 directory

```
---
  - name: register variable example
    hosts: local
    tasks:
      - name: run a shell command and register result
        shell: "/sbin/ifconfig eth1"
        register: result

      - name: print registered variable
        debug: var=result
```

Execute the playbook to display information about the registered variable.

```
ansible-playbook  register.yml
```

## Adding support for Ubuntu

Apache role that we have developed supports only RedHat based systems at the moment. To add support for ubuntu (app2), we must handle platform specific differences.

e.g.

|   | RedHat | Debian     |
| :------------- | :------------- | :------------- |
| Package Name | httpd       | apache2       |
| Service Name | httpd       | apache2       |

OS specific configurations can be defined by creating role vars and by including those in tasks.

file: roles/apache/vars/RedHat.yml

```
---
apache:
  package:
    name: httpd
  service:
    name: httpd
    status: started
```

file: roles/apache/vars/Debian.yml

```
---
apache:
  package:
    name: apache2
  service:
    name: apache2
    status: started
```

Lets now selectively include those var files from tasks/main.yml .  Also selectively call configurations.
file: role/apache/tasks/main.yml

```
---
# tasks file for apache
  - include_vars: "{{ ansible_os_family }}.yml"
  - include: install.yml
  - include: start.yml
  - include: config_{{ ansible_os_family }}.yml  
```

We are now going to create two different config tasks. Since the current config is applicable to RedHat, lets rename it to config_RedHat.yml

```
mv roles/apache/tasks/config.yml roles/apache/tasks/config_RedHat.yml
```

We will now create a new config for Debian

file: roles/apache/tasks/config_Debian.yml

```
- name: Copying index.html file...
  template: >
    src=index.html.j2
    dest=/var/www/html/index.html
    mode=0777
```

Update tasks and handlers to install and start the correct service

tasks/install.yml

```
---
  - name: install httpd on centos
    package: >
      name={{ apache['package']['name']}}
      state=installed
```

tasks/start.yml

```
---
  - name: start httpd service
    service: >
      name={{ apache['service']['name']}}
      state={{ apache['service']['status']}}
```

handlers/main.yml

```
---
# handlers file for apache
  - name: restart apache service
    service: >
      name={{ apache['service']['name']}}
      state=restarted
```

## Exercises

* Create host specific variables in host_vars/HOSTNAME for one of the app servers, and define some variables values specific to the host. See the output after applying playbook on this node.
* Generate MySQL Configurations dynamically using templates and modules.
  * Create a template for my.cnf.  Name it as roles/mysql/templates/my.cnf.j2
  * Replace parameter values with templates variables
  * Define variables in role defaults.
