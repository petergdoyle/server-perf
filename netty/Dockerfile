
FROM petergdoyle/oraclejdk:8

COPY nettybackend/target/TestBackend-0.0.1-SNAPSHOT.jar /nettybackend/target/TestBackend-0.0.1-SNAPSHOT.jar
COPY nettybackend/target/lib/ /nettybackend/target/lib/

WORKDIR /nettybackend

#EXPOSE 5060

CMD /bin/bash
