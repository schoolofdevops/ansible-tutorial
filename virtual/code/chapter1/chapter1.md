## Chapter 3

# 3.1 Creating Project specific ansible


# 3.2 Setting up inventory of hosts
## Inventories:

For creating inventories change your working directory to "/etc/ansible/hosts"
<pre><code> cd /etc/ansible/hosts
</code></pre>

Create a new file called newhosts.ini
<pre><code> touch *newhosts.ini*
</code></pre>

Let's create a group called db
<pre><code>
[db]
192.168.61.11
</code></pre>

Adding other groups to the inventory file
<pre><code>
[app]
192.168.61.12
192.168.61.13
</code></pre>

Now save and quit the file. This is called an inventory and this is how it should look like...
<pre><code>
[db]
192.168.61.11

[app]
192.168.61.12
192.168.61.13
</code></pre>

Make sure it has a *.ini* extension.


# 3.3 Setting up passwordless ssh access to inventory hosts

# 3.4 Ad Hoc Commands:
### Task 1
Now we will execute ping command.
<pre><code>
ansible all -m ping
</code></pre>

### Task 2
Need a little more test?
<pre><code>
ansible app -s -m yum -a "name=ntp state=present"
</code></pre>

### Task 3
The true power of adhoc!
<pre><code>
ansible app -s -B 3600 -a "yum -y update"
</code></pre>

## Exercises :
### Try these...
1. Add another group called *lb* in inventory with respective host ip
2. Add a user called *joe* to the *app* host group. Make sure that user has a home using appropriate Ad-Hoc command.
3. Install the package cowsay using the correct Ad-Hoc command.
