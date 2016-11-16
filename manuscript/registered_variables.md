(src: http://docs.ansible.com/ansible/test_strategies.html)

tasks:

  - action: uri url=http://www.example.com return_content=yes
    register: webpage

  - fail: msg='service is not happy'
    when: "'AWESOME' not in webpage.content"



tasks:

   - shell: /usr/bin/some-command --parameter value
     register: cmd_result

   - assert:
       that:
         - "'not ready' not in cmd_result.stderr"
         - "'gizmo enabled' in cmd_result.stdout"



tasks:

   - stat: path=/path/to/something
     register: p

   - assert:
       that:
         - p.stat.exists and p.stat.isdir    
