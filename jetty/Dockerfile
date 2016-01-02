FROM petergdoyle/oraclejdk:8

RUN curl -O http://download.eclipse.org/jetty/stable-9/dist/jetty-distribution-9.3.6.v20151106.tar.gz \
  && mkdir -p /jetty \
  && tar -xvf jetty-distribution-9.3.6.v20151106.tar.gz -C /jetty \
  && ln -s /jetty/jetty-distribution-9.3.6.v20151106/ /jetty/default \
  && rm -f jetty-distribution-9.3.6.v20151106.tar.gz

COPY etc/* /jetty/default/etc/

ENV BASE_VOL /base

WORKDIR $BASE_VOL

#EXPOSE 8080 1099
