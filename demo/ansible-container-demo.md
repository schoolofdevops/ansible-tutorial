## Ansible Container Demo  
### Working Directory = /ansible-container-demo
### EC2 = ansible-demo-controller
### Prerequisites

* Python 2.7
* pip
* setuptools 20.0.0+
* Docker 1.11 or access to a Docker daemon. If you’re installing Docker Engine or accessing a remote Docker daemon, see Configuring Docker.

#### Installing Pip

`sudo yum install python-pip python-wheel`

`sudo yum upgrade python-setuptools`

`pip -V`

`pip install --upgrade pip`

#### Installing Setuptools 20.0.0+

`wget https://bootstrap.pypa.io/ez_setup.py -O - | sudo python`

#### Installing Docker 1.11

Follow the [link](https://docs.docker.com/engine/installation/linux/centos/) for installation.

### How it works

Use Ansible Container to manage container lifecycle from development, through testing, to production:

* `ansible-container init`

  Creates a directory *ansible* with files to get you started. Read the comments and edit to suit your needs.

* `ansible-container build`

  Creates images from your Ansible playbooks.

* `ansible-container run`

  Launches the containers specified in the orchestration document, *container.yml*, for testing the built images. The
  format of *container.yml* is nearly identical to Docker Compose.

* `ansible-container push`

  Pushes the project's images to a container registry of your choice.

* `ansible-container shipit`

  Generates the necessary playbook and role to deploy your containers on a supported cloud provider.

### Demo

`pip install ansible-container`

Create a directory `mkdir /ansible_container_demo` and cd into it.

git clone https://github.com/ansible/ansible-container-examples.git

Change your working directory to `/ansible_container_demo/ansible-container/example`

Get into each of the example folder and start building it.

`ansible-container build`

After Building give a *run command* to run the containers.

`ansible-container run`

### Removing all docker

`docker rm -f $(docker ps -a -q) && docker rmi $(docker images -q) && docker ps -a | cut -c-12 | xargs docker rm`

### Removing all exited docker container

`docker rm $(docker ps -q -f status=exited)`
`docker rmi $(docker images | grep "latest" | awk "{print $3}")`

### Installing Ansible Container in virtualenv

> If you do not have root privileges, you’ll need to use a virtualenv to create a Python sandbox

>virtualenv is most preferable

`pip install virtualenv`

Create a directory `mkdir /ansible_container_demo` and cd into it.

`cd /ansible_container_demo`

`virtualenv ansible-container`

`source ansible-container/bin/activate`

`pip install --upgrade pip`

`pip install --upgrade setuptools`

`pip install ansible-container`
