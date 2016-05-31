
FROM server-perf/basejdk

RUN curl -O http://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/9.3.9.v20160517/jetty-distribution-9.3.9.v20160517.tar.gz \
  && mkdir -p /jetty \
  && tar -xvf jetty-distribution-9.3.9.v20160517.tar.gz -C /jetty \
  && ln -s /jetty/jetty-distribution-9.3.9.v20160517/ /jetty/default \
  && rm -f jetty-distribution-9.3.9.v20160517.tar.gz

COPY etc/* /jetty/default/etc/
COPY base/ /base/

WORKDIR /base

#EXPOSE 8080 1099
