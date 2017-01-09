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

## Setting up passwordless ssh access to inventory hosts

### Generating ssh keypair on control host

Now on control host, execute the following command

```
ssh-keygen -t rsa
```

Now press enter for the passphrase and other queries.

```
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
c5:a5:6d:60:56:5a:7b:3c:60:23:b5:0f:1b:cf:f9:fd root@ansible
The key's randomart image is:
+--[ RSA 2048]----+
|          =oO    |
|         + X *   |
|          = B +  |
|         . . O o |
|        S   . =  |
|               ..|
|                o|
|                .|
|                E|
+-----------------+
```

### Copying public key to inventory hosts

Copy public key of control node to other hosts

```
ssh-copy-id vagrant@192.168.61.11

ssh-copy-id vagrant@192.168.61.12

ssh-copy-id vagrant@192.168.61.13

ssh-copy-id vagrant@192.168.61.14
```

See this example output to verify with your output

```
The authenticity of host '192.168.61.11 (192.168.61.11)' can't be established.
RSA key fingerprint is 32:7f:ad:d7:da:63:32:b6:a9:ff:59:af:09:1e:56:22.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.61.11' (RSA) to the list of known hosts.
```

The password for user *vagrant* is *vagrant*
