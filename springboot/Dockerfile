
FROM petergdoyle/oraclejdk:8

COPY gs-actuator-service /springboot

WORKDIR /springboot

RUN mvn clean install

EXPOSE 5070

CMD java -jar target/springboot-1.0-SNAPSHOT.jar
