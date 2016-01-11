FROM centos:7

RUN yum -y update && yum clean all

#
# enable epel repo
#
RUN yum -y install epel-release

#
# enable rpmforge yum repo
#
RUN yum -y install \
  http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm

#
# basic make life easier stuff
#
RUN yum -y install vim bash-completion tree git curl wget telnet

#
# required for some containers to keep running
#
RUN yum -y install supervisor

#
# monitoring and system tools that containers can run docker
#
RUN yum -y install iperf net-tools \
iftop htop nmon netstat dstat htop \
wireshark tcpdump sysstat

#
# install nicstat - fails on CentOS 7 - excluding for now
#
#RUN yum -y install gcc gcc-c++ glibc.i686 glibc-devel.i686 make \
#&& mkdir /usr/nicstat \
#&& curl -L -o /usr/nicstat/nicstat-1.95.tar.gz http://downloads.sourceforge.net/project/nicstat/nicstat-1.95.tar.gz \
#&& cd /usr/nicstat \
#&& tar -xvf nicstat-1.95.tar.gz \
#&& ln -s /usr/nicstat/nicstat-1.95 default \
#&& cd /usr/nicstat/default \
#&& mv Makefile.Linux Makefile \
#&& make \
#&& rm nicstat-1.95.tar.gz
#&& ln -s /usr/nicstat/default/.nicstat.RedHat_5_i386 /usr/nicstat/default/nicstat \
#&& alternatives --install "/usr/bin/nicstat" "nicstat" "/usr/nicstat/default/nicstat" 99999

CMD ["/bin/bash"]
