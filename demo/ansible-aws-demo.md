## Ansible AWS Demo  
### Working Directory = /ansible_aws_demo
### EC2 = ansible-training-tower-aws-demo-centos

In controller machine add an environmental variables.

```
export AWS_ACCESS_KEY_ID='AKIAJ4CTTXL5QA2M3RIQ'
export AWS_SECRET_ACCESS_KEY='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'
```

Create a playbook as follows,

```
---
- hosts: localhost
  connection: local
  gather_facts: False

  tasks:

    - name: Provision a set of instances
      ec2:
         key_name: ansible-training
         group: open
         instance_type: t2.micro
         image: "ami-2051294a"
         vpc_subnet_id: subnet-f6a15fae
         wait: true
         exact_count: 2
         region: us-east-1
         count_tag:
            Name: ansible_play_created
         instance_tags:
            Name: ansible_play_created
      register: ec2

    - command: /ansible_aws_demo/ec2.py

- hosts: tag_Name_ansible_play_created
  user: ec2-user
  sudo: yes

  tasks:
    - command: touch /tmp/created_by_play.txt
```
