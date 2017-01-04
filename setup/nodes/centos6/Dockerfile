FROM centos:6
MAINTAINER babu <babu@initcron.org>

LABEL env=des

RUN yum -y install openssh-server shadow-utils sudo

COPY motd.sh /opt/

RUN chmod +x /opt/motd.sh && \
    sh /opt/motd.sh && \
    rm -rf /opt/motd.sh

RUN echo -e "service sshd start && service sshd stop && \
    useradd devops && \
    echo 'devops:codespaces' | chpasswd && \
    /usr/sbin/sshd -D" > /bootstrap.sh

RUN echo 'devops ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

EXPOSE 22
CMD ["/bin/bash","/bootstrap.sh"]
