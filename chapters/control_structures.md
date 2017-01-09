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
