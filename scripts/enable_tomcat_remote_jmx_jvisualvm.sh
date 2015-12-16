
#determine oracle JDK_HOME
#on Mac OS x
find_jdk_cmd='/usr/libexec/java_home -v 1.8'
jdk_home="$($find_jdk_cmd)"
echo $jdk_home

#first make sure there is a jdk
if [ ! -d "$jdk_home" ]; then
  echo "cannot find jdk home";
  return 1;
fi

#then make sure there is a visualvm available
if [ ! -d "$jdk_home/lib/visualvm" ]; then
  echo "cannot find visualvm";
  return 1;
fi

#download the catalina-jmx-remote jar so it will be include in the classpath of the jvisualvm executiable
#this command is to be run as root or sudo
curl -o $jdk_home/lib/visualvm/platform/lib/catalina-jmx-remote.jar \
http://apache.go-parts.com/tomcat/tomcat-8/v8.0.28/bin/extras/catalina-jmx-remote.jar
