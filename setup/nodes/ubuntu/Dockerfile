FROM       ubuntu:16.04
MAINTAINER Babu <babu@initcron.org>

RUN apt-get update

RUN apt-get install -y openssh-server sudo vim python python-apt python-pip
RUN mkdir /var/run/sshd

COPY motd.sh /opt/

RUN chmod +x /opt/motd.sh && \
    sh /opt/motd.sh && \
    rm -rf motd.sh

#RUN echo 'root:123456' |chpasswd

RUN useradd -ms /bin/bash devops && \
    echo 'devops:codespaces' |chpasswd && \
    adduser devops sudo

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

EXPOSE 22
CMD    ["/usr/sbin/sshd", "-D"]
