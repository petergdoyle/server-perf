
FROM petergdoyle/oraclejdk:8

COPY src /springboot/src
COPY pom.xml /springboot/pom.xml

WORKDIR /springboot

RUN mvn clean install

EXPOSE 5070

CMD java -jar target/springboot-1.0-SNAPSHOT.jar
