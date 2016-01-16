
FROM server-perf/base

# some tools need to be built so need some compilers and make
RUN yum -y install gcc gcc-c++ make

# install apache-bench ab
RUN yum -y install httpd-tools

# install httpress
RUN yum -y install httpress

# install siege
RUN yum -y install siege

# install httperf - requires rpmforge repo
RUN yum -y install httperf

#
# install autobench - requires httperf !
# needs a modification so that httperf hogs the resources for a benchmark
#
RUN git clone https://github.com/menavaur/Autobench.git \
&& cd Autobench \
&& sed -i.bak 's/httperf --server/httperf --hog --server/' autobench \
&& make \
&& make install \
&& cd - \
&& rm -fr Autobench

#
# install wrk
#
RUN yum -y install openssl-devel \
&& git clone https://github.com/wg/wrk.git \
&& cd wrk \
&& make \
&& mv wrk /usr/bin \
&& cd - \
&& rm -fr wrk

#
# install jmeter - change the base to server-perf/basejdk
#
#RUN mkdir -p /jmeter \
#  && curl -O http://www.eu.apache.org/dist/jmeter/binaries/apache-jmeter-2.13.tgz \
#  && tar -xvf apache-jmeter-2.13.tgz -C /jmeter \
#  && ln -s /jmeter/apache-jmeter-2.13 /jmeter/default \
#  && rm -f apache-jmeter-2.13.tgz

# install weighttp
RUN yum -y install libev libev-devel \
&& git clone https://github.com/lighttpd/weighttp.git \
&& cd weighttp \
&& ./waf configure \
&& ./waf build \
&& ./waf install \
&& cd - \
&& rm -fr weighttp

WORKDIR /

CMD /bin/bash
