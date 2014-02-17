# General build RPM environment for CentOS 6.x
#
# VERSION       0.0.1

FROM centos
MAINTAINER Kentaro Yoshida "https://github.com/y-ken"

# Install up-to-date epel rpm repository
RUN yum -y install http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# Install various packages to get compile environment
RUN yum -y groupinstall 'Development Tools'

# Install git command to access GitHub repository
RUN yum -y install git

# Install rpm-build to use rpmrebuild command
RUN yum -y install rpm-build

# Install yum-utils to use yumdownloader command
RUN yum -y install yum-utils

# Install rpmdevtools to use rpmdev-setuptree command
RUN yum -y install rpmdevtools

# Setup rpm build configuration for root user
RUN rpmdev-setuptree
RUN echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros

# Setup rpm build configuration for general user 'build'
RUN yum -y install sudo
RUN sed -i 's/requiretty/!requiretty/' /etc/sudoers
RUN echo 'build ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN useradd -d /home/build -p `openssl passwd -1 "build"` build
RUN sudo -ubuild rpmdev-setuptree
RUN sudo -ubuild echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros

# Execute on `docker run` command
ENV HOME /root
WORKDIR /root/rpmbuild
CMD /bin/bash --login
