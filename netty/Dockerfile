
FROM petergdoyle/oraclejdk:8

COPY nettybackend /nettybackend

WORKDIR /nettybackend

RUN mvn clean install

#EXPOSE 5060

CMD java -jar target/TestBackend-0.0.1-SNAPSHOT.jar
