
FROM petergdoyle/oraclejdk:8

# some tools need to be built so need some compilers and make
RUN yum -y install gcc gcc-c++ make

# install apache-bench ab
RUN yum -y install httpd-tools

# install httpress
RUN yum -y install httpress

# install other tools
RUN yum -y install iperf netstat dstat htop

# install siege
RUN yum -y install siege

# install httperf
RUN wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm \
&& yum -y localinstall rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm \
&& yum -y install httperf \
&& rm -f rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm

# install autobench - requires httperf !
RUN git clone https://github.com/menavaur/Autobench.git \
&& cd Autobench \
&& sed -i.bak 's/httperf --server/httperf --hog --server/' autobench \
&& make \
&& make install \
&& rm /Autobench

# install jmeter
RUN mkdir -p /jmeter \
&& curl -O http://www.eu.apache.org/dist/jmeter/binaries/apache-jmeter-2.13.tgz \
  && tar -xvf apache-jmeter-2.13.tgz -C /jmeter \
  && ln -s /jmeter/apache-jmeter-2.13 /jmeter/default \
  && rm -f apache-jmeter-2.13.tgz

# install weighttp
RUN yum -y install libev libev-devel \
&& git clone https://github.com/lighttpd/weighttp.git \
&& cd weighttp \
&& ./waf configure \
&& ./waf build \
&& ./waf install \
&& rm /weighttp

WORKDIR /

CMD /bin/bash
