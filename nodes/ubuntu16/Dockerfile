FROM ubuntu:16.04
# base config
# https://docs.docker.com/engine/examples/running_ssh_service/#build-an-eg_sshd-image

# install ssh server & python2.x(for ansible)
RUN apt-get update \
    && apt-get install -y openssh-server sudo python

# start ssh
RUN /etc/init.d/ssh restart

# change root password
RUN echo 'root:screencast' | chpasswd

RUN sed -ri 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^#RSAAuthentication yes/RSAAuthentication yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]