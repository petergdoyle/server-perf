
FROM petergdoyle/oraclejdk:8

COPY gs-actuator-service /gs-actuator-service

WORKDIR /gs-actuator-service

RUN mvn clean install

EXPOSE 5070

CMD java -jar target/gs-actuator-service-0.1.0.jar
