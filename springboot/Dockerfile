
FROM petergdoyle/oraclejdk:8

COPY  target/springboot-tomcat-1.0-SNAPSHOT.jar /springboot/target/springboot-tomcat-1.0-SNAPSHOT.jar
COPY  target/springboot-undertow-1.0-SNAPSHOT.jar  /springboot/target/springboot-undertow-1.0-SNAPSHOT.jar

WORKDIR /springboot

#EXPOSE 5070 5075

CMD /bin/bash
