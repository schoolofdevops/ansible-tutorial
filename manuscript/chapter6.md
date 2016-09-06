# Chapter 6  
## Dynamic Code - Variables and Templates  
In this  tutorial, we  are going to make the roles that we created earlier dynamic by adding templates and defining varaibles.

### 6.1 Variables  

Variables are of two types
  * Automatic Variables/ Facts
  * User Defined Variables

Lets try to discover information about our systems by using facts.

#### Finding Facts About Systems

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
            ],
            "ansible_architecture": "x86_64",
            "ansible_bios_date": "12/01/2006",
            "ansible_bios_version": "VirtualBox",
            "ansible_cmdline": {
                "KEYBOARDTYPE": "pc",
                "KEYTABLE": "us",
                "LANG": "en_GB.UTF-8",
                "SYSFONT": "latarcyrheb-sun16",
                "quiet": true,
                "rd_LVM_LV": "VolGroup/lv_root",
                "rd_NO_DM": true,
                "rd_NO_LUKS": true,
                "rd_NO_MD": true,
                "rhgb": true,
                "ro": true,
                "root": "/dev/mapper/VolGroup-lv_root"
            },
            "ansible_date_time": {
                "date": "2016-09-05",
                "day": "05",
                "epoch": "1473104372",
                "hour": "20",
                "iso8601": "2016-09-05T19:39:32Z",
                "iso8601_basic": "20160905T203932677277",
                "iso8601_basic_short": "20160905T203932",
                "iso8601_micro": "2016-09-05T19:39:32.677365Z",
                "minute": "39",
                "month": "09",
                "second": "32",
                "time": "20:39:32",
                "tz": "BST",
                "tz_offset": "+0100",
                "weekday": "Monday",
                "weekday_number": "1",
                "weeknumber": "36",
                "year": "2016"
            }

```

#### Filter facts  

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

#### Registering  Variables
  Lets create a playbook to run a shell command, register the result and display the value of registered variable.

  Create **register.yml** in chap6 directory
```
---
  - name: register variable example
    hosts: local
    tasks:
      - name: run a shell command and rerister result
        shell: "/sbin/ifconfig eth1"
        register: result

      - name: print registered variable
        debug: var=result
```

Execute the playbook to display information about the registered variable.
```
ansible-playbook  register.yml

```


### 6.2 Creating Templates for Apache
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


  * Define values of the variables used in the templates above.  The default values are defined in *roles/apache/defaults/main.yml* . Lets edit that file and add the following,   

  ```
  ---
  apache_port: 80
  custom_root: /var/www/html
  apache_index: index.html
  ```  

  * Create a template for index.html as well

    ``` cp roles/apache/files/index.html roles/apache/templates/index.html.j2 ```

  * Add the following contents to index.html.j2
```
<html>
<body>
  <h1>  Welcome to Ansible training! </h1>

  <h2> SYSTEM INFO </h2>
  <h3> Operating System : {{ ansible_distribution }} </h3>
  <h3> IP Address : {{ ansible_eth1['ipv4']['address'] }} </h3>
</body>
</html>
```

  * Since we are now using template instead of static file, we need to edit *roles/apache/tasks/config.yml* file and use template module
  * Replace **copy** module with **template** modules as follows,  
  ```
  ---
  - name: Creating configuration from templates...
    template: src=httpd.conf.j2
              dest=/etc/httpd.conf
              owner=root group=root mode=0644
    notify: Restart apache service
  - name: Copying index.html file...
    template: src=index.html.j2
          dest=/var/www/html/index.html
          mode=0777
  ```  
  * Delete httpd.conf and index.html in files directory  
  ```
  rm roles/apache/files/httpd.conf
  rm roles/apache/files/index.html

  ```

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

TASK [base : create admin user] ************************************************
ok: [192.168.61.13]
ok: [192.168.61.12]

TASK [base : remove dojo] ******************************************************
ok: [192.168.61.12]
ok: [192.168.61.13]

TASK [base : install tree] *****************************************************
ok: [192.168.61.12]
ok: [192.168.61.13]

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

TASK [apache : Creating configuration templates...] ****************************
changed: [192.168.61.12]
changed: [192.168.61.13]

TASK [apache : Copying index.html file...] *************************************
changed: [192.168.61.12]
changed: [192.168.61.13]

RUNNING HANDLER [apache : Restart apache service] ******************************
changed: [192.168.61.12]
changed: [192.168.61.13]

PLAY RECAP *********************************************************************
192.168.61.12              : ok=11   changed=3    unreachable=0    failed=0
192.168.61.13              : ok=11   changed=3    unreachable=0    failed=0

  ```   
  * For better understanding, check your apache tree with the one mentioned below  
  ```
  roles/apache
  ├── defaults
  │   └── main.yml
  ├── files
  ├── handlers
  │   └── main.yml
  ├── meta
  │   └── main.yml
  ├── README.md
  ├── tasks
  │   ├── config.yml
  │   ├── install.yml
  │   ├── main.yml
  │   └── start.yml
  ├── templates
  │   └── httpd.conf.j2
  |   └── index.html.j2
  ├── tests
  │   ├── inventory
  │   └── test.yml
  └── vars
      └── main.yml

  ```  

## Exercise

  * Generate MySQL Configurations dynaically using templates and modules.
    * Create a template for my.cnf.  Name it as roles/mysql/templates/my.cnf.j2
    * Replace parameter values with tempates variables
    * Define variables in role defaults.
