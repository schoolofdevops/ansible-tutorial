Troubleshooting Techniques
  * Useing verbose mode
  * Using --start-at-task
  * Using --step
  * Using debugger

Verbose Mode
 -vvvv

Debugger

http://docs.ansible.com/ansible/playbooks_debugger.html

Defining Failure
failed_when: "'FAILED' in command_result.stderr"
http://docs.ansible.com/ansible/playbooks_error_handling.html

start-at-task
ansible-playbook playbook.yml --start-at-task="install packages"

Step
Playbooks can also be executed interactively with --step:

ansible-playbook playbook.yml --step
This will cause ansible to stop on each t


http://docs.ansible.com/ansible/playbooks_startnstep.html
