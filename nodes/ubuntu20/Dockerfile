FROM ubuntu:20.10

# Set non interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Variable for work user
ARG WORKUSER=work_user
ARG USER_UID=1001
ARG USER_GID=$USER_UID

# base config
# https://docs.docker.com/engine/examples/running_ssh_service/#build-an-eg_sshd-image

# Install sshd, sudo, python3.x(for ansible)
RUN apt-get update \
    && apt-get install -y openssh-server sudo python3 vim

# change root password
RUN echo 'root:p@ssw0rd' | chpasswd \
    # Add group & user for work user
    && groupadd --gid $USER_GID $WORKUSER \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $WORKUSER \
    # Set sudo for work user
    && echo $WORKUSER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$WORKUSER \
    && chmod 0440 /etc/sudoers.d/$WORKUSER

# Copy SSH key
COPY ./ansible_rsa.pub /root/.ssh/authorized_keys
COPY ./ansible_rsa.pub /home/$WORKUSER/.ssh/authorized_keys

# Set authorized_keys permission
RUN chown root:root -R /root/.ssh \
    && chown $WORKUSER:$WORKUSER -R /home/$WORKUSER/.ssh \
    && chmod 500 /root/.ssh \
    && chmod 500 /home/$WORKUSER/.ssh \
    && chmod 400 /root/.ssh/* \
    && chmod 400 /home/$WORKUSER/.ssh/* \
    && mkdir /var/run/sshd \
    # Set allow root login
    && sed -ri 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config \
    # Set disallow password login
    && sed -ri 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config \
    # Set allow  no password login
    && sed -ri 's/^#PermitEmptyPasswords yes/PermitEmptyPasswords yes/' /etc/ssh/sshd_config \
    # SSH login fix. Otherwise user is kicked off after login
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /tmp/gotools

EXPOSE 22

# Set dialog mode
ENV DEBIAN_FRONTEND=dialog

# Run sshd
CMD ["/usr/sbin/sshd", "-D"]