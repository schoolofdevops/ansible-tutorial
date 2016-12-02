

Ansible vs Chef/Puppet

 * applying a role applies only tasks/main.yml. There is no direct way to
   apply individual tasks e.g. apache::install. Puppet/chef both have this.

 * Registered variables: its possible to register the result of a command as a variable, based on which decisions can be made, as well as results can be passed to next tasks.

 * Push vs Pull Model

 * Scale. Puppet/Chef can scale better imho

 * Ansible Tower is expensive, not per node.

 * Custom modules for ansible can be written in any language. Does not have to be python. Modules return JSON data.
