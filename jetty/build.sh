
rm -fr base/webapps/*

mvn clean install

mv target/jetty-1.0-SNAPSHOT.war base/webapps/
