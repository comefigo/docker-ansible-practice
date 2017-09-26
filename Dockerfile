FROM ansible/centos7-ansible:latest

# add ansible hosts
ADD ./config/ansible_hosts /etc/ansible/hosts

# add ansible config to user dir
ADD ./config/ansible.cfg /root/.ansible.cfg

# copy ssh keys
ADD ./ssh/ansible_rsa /root/.ssh/
ADD ./ssh/ansible_rsa.pub /root/.ssh/
RUN chmod 700 /root/.ssh
RUN chmod 600 /root/.ssh/*

CMD ["/sbin/init", "-D"]