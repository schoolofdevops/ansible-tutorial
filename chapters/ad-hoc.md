# Getting Started with Ansible (Ad Hoc Server Management)

## Creating Project Specific Ansible Configuration

The default configurations for ansible resides at /etc/ansible/ansible.cfg. Instead of relying on defaults, we are going to creates  a custom configuration file for our project. The advantage with that is we could take this configurations on any host and execute it the same way, without touching the default system configurations.  This custom configurations will essentially  override the values in /etc/ansible/ansible/cfg.

###  Ansible configuration file

Change into /vagrant/code/chap3 directory on your ansible host. Create a file called ansible.cfg  Add  the following contents to the file.

On Ansible Control node,

```
mkdir /vagrant/code/chap3
cd /vagrant/code/chap3
```

Create **ansible.cfg** in chap3

```
[defaults]
remote_user = vagrant
inventory   = myhosts.ini
```

## Creating Host Inventory

Create a new file called *myhosts.ini* in the same directory.
Let's create three groups as follows,

```
[local]
localhost ansible_connection=local

[app]
192.168.61.12
192.168.61.13

[db]
192.168.61.11
```

* First group contains the localhost, the control host. Since it does not need to be connected over ssh, it mandates we add ansible_connection=local option
* Second group contains  Application Servers. We will add  two app servers to this group.
* Third group holds the information about the database servers.

The inventory file should look like below.
