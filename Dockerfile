FROM centos

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum -y install openssh-server

RUN useradd remote_user && \
    echo "remote_user:1234" | chpasswd && \
    mkdir /home/remote_user/.ssh && \
    chmod 700 /home/remote_user/.ssh

COPY id_rsa.pub /home/remote_user/.ssh/authorized_keys

RUN chown remote_user:remote_user -R /home/remote_user/.ssh/ && \
	chmod 600 /home/remote_user/.ssh/authorized_keys

RUN curl -O "https://bootstrap.pypa.io/get-pip.py"
RUN yum -y install python3.8
RUN python3.8 get-pip.py
RUN pip install awscli --upgrade

	
RUN ssh-keygen -A
RUN rm -rf /run/nologin

RUN yum -y install mysql

CMD /usr/sbin/sshd -D
