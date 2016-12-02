### Preparing Ansible host

```
sudo yum install python-pip
sudo pip install "pywinrm>=0.1.1"
```

### Preparing Windows Host

  * Create a file and paste the below github content and save “PowerShell Scripts (* .ps1)”.

https://github.com/ansible/ansible/blob/devel/examples/scripts/ConfigureRemotingForAnsible.ps1

  * Double Click the file or open powershell and Execute it from the file path. winrm will be configured

### Setting up inventory and inventory vars

  * Add windows host to inventory by editing myhosts.ini

```
	[windows]
  windows_host_ip_or_hostname
```

Create group vars for windows group
	- Create group_vars/windows.yml

```
	ansible_ssh_user: <admin user>
	ansible_ssh_pass: <admin user password>
	ansible_ssh_port: 5986
	ansible_connection: winrm
	ansible_winrm_server_cert_validation: ignore
```


Validate Connectivity

```
ansible windows -i host -m win_ping
ansible windows -i host -m setup

```

Create a Sample Playbook : windows.yml

```
---
- name: test raw module
  hosts: windows
  tasks:
    - name: run ipconfig
      raw: ipconfig
      register: ipconfig

    - debug: var=ipconfig

    - name: test stat module on file
      win_stat: path="C:/Windows/win.ini"
      register: stat_file

    - debug: var=stat_file

    - name: check stat_file result
      assert:
          that:
             - "stat_file.stat.exists"
             - "not stat_file.stat.isdir"
             - "stat_file.stat.size > 0"
             - "stat_file.stat.md5"

    - name: Install IIS
      win_feature:
        name: "Web-Server"
        state: absent
        restart: yes
        include_sub_features: yes
        include_management_tools: yes
```

Execute Playbook as

```
ansible-playbook windows.yml

```


Reference
=========

http://darrylcauldwell.com/how-to-setup-an-ansible-test-lab-for-windows-managed-nodes-custom-windows-modules/
http://docs.ansible.com/ansible/intro_windows.html
