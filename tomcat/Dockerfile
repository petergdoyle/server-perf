

FROM server-perf/basejdk

RUN curl -L -O http://www.gtlib.gatech.edu/pub/apache/tomcat/tomcat-8/v8.0.30/bin/apache-tomcat-8.0.30.tar.gz \
  && mkdir -p /tomcat \
  && tar -xvf apache-tomcat-8.0.30.tar.gz -C /tomcat \
  && ln -s /tomcat/apache-tomcat-8.0.30 /tomcat/default \
  && rm -f apache-tomcat-8.0.30.tar.gz

#RUN curl -L -o /tomcat/default/lib/catalina-jmx-remote.jar http://www.gtlib.gatech.edu/pub/apache/tomcat/tomcat-8/v8.0.30/bin/extras/catalina-jmx-remote.jar
#COPY setenv.sh /tomcat/default/bin/

COPY conf/* /tomcat/default/conf/
COPY webapps/*war /tomcat/default/webapps/

CMD /bin/bash
