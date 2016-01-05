
FROM petergdoyle/oraclejdk:8

COPY springboot-tomcat/target/springboot-tomcat-1.0-SNAPSHOT.jar /springboot/springboot-tomcat/target/springboot-tomcat-1.0-SNAPSHOT.jar
COPY springboot-undertow/target/springboot-undertow-1.0-SNAPSHOT.jar  /springboot/springboot-undertow/target/springboot-undertow-1.0-SNAPSHOT.jar

WORKDIR /springboot 

#EXPOSE 5070 5075

CMD /bin/bash
