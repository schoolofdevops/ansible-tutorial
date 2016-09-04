# Chapter 3

## 3.1 Creating project specific ansible configuration
###  Ansible configuration file
In chapter3 directory create a file called ansible.cfg
Put the following content in ansible.cfg
{title="Listing ", lang=html, linenos=off}
~~~~~~~
[defaults]

remote_user = vagrant
inventory   = myhosts.ini
~~~~~~~

## 3.2 Setting up inventory of hosts
### Inventories:

For setting up inventories, create a new file called *myhosts.ini*.  
Let's create a group called *localhost* by editing myhosts.ini
{title="Listing ", lang=html, linenos=off}
~~~~~~~
[local]
localhost ansible_connection=local
~~~~~~~
Adding other groups to the inventory file
{title="Listing ", lang=html, linenos=off}
~~~~~~~
[app]
192.168.61.12
192.168.61.13

[db]
192.168.61.11
~~~~~~~

Now save and quit the file. This is called an inventory and this is how it should look like...
{title="Listing ", lang=html, linenos=off}
~~~~~~~
[local]
localhost ansible_connection=local

[app]
192.168.61.12
192.168.61.13

[db]
192.168.61.11

~~~~~~~

Make sure it has a *.ini* extension.


## 3.3 Setting up passwordless ssh access to inventory hosts
### 3.3.1 Generating ssh keypair on control host
Now on control host, execute the following command
{title="Listing ", lang=html, linenos=off}
~~~~~~~
ssh-keygen -t rsa
~~~~~~~
### 3.3.2 Copying public key to inventory hosts
Copy public key of control node to other hosts
{title="Listing ", lang=html, linenos=off}
~~~~~~~
ssh-copy-id vagrant@192.168.61.11

ssh-copy-id vagrant@192.168.61.12

ssh-copy-id vagrant@192.168.61.13
~~~~~~~
### 3.3.3 Validate the passwordless login
Let us check the connection of control node with other hosts
{title="Listing ", lang=html, linenos=off}
~~~~~~~
ssh vagrant@192.168.61.11

ssh vagrant@192.168.61.12

ssh vagrant@192.168.61.13
~~~~~~~
### 3.3.4 Ansible ping
We will use Ansible to make sure all the hosts are reachable
{title="Listing ", lang=html, linenos=off}
~~~~~~~
ansible all -m ping
~~~~~~~

## 3.4 Ad Hoc commands:
Try running following Ad-Hoc commands...
### 3.4.1 Run *hostname* command on all hosts
Let us print the hostname of all the hosts
{title="Listing ", lang=html, linenos=off}
~~~~~~~
ansible all -a hostname
~~~~~~~
### 3.4.2 Check the *uptime*
How long the hosts are *up*?
{title="Listing ", lang=html, linenos=off}
~~~~~~~
ansible all -a uptime
~~~~~~~
### 3.4.3 Check memory info on app servers
Does my app servers have any disk space *free*?
{title="Listing ", lang=html, linenos=off}
~~~~~~~
ansible app -a free
~~~~~~~
### 3.4.4 Installing packages
Let us *install* Docker on app servers
{title="Listing ", lang=html, linenos=off}
~~~~~~~
ansible app -a "yum install -y docker-engine"
~~~~~~~
This command will fail. Run the fillowing command with sudo permissions.
{title="Listing ", lang=html, linenos=off}
~~~~~~~
ansible app -s -a "yum install -y docker-engine"
~~~~~~~
### 3.4.5 Running commands one machine at a time
Do you want a command to run on *one machine at a time* ?
{title="Listing ", lang=html, linenos=off}
~~~~~~~
ansible all -f 1 -a "free"
~~~~~~~
## 3.5 Using *modules* to manage the state of infrastructure
### 3.5.1 Creating users and groups using *user* and *group*
To create a group
{title="Listing ", lang=html, linenos=off}
~~~~~~~
ansible app -s -m group -a "name=admin state=present"
~~~~~~~
To create a user
{title="Listing ", lang=html, linenos=off}
~~~~~~~
ansible app -s -m user -a "name=devops group=admin createhome=yes"
~~~~~~~

### 3.5.2 Copy a file using *copy* modules
We will copy file from control node to app servers.
{title="Listing ", lang=html, linenos=off}
~~~~~~~
ansible app -m copy -a "src=/vagrant/code/test.txt dest=/tmp/test.txt"
~~~~~~~

## 3.6 Exercises :
### Try these...
1. Add another group called *lb* in inventory with respective host ip
2. Add a user called *joe* app servers. Make sure that user has a home directory.
3. Install the package cowsay using the correct Ad-Hoc command.
