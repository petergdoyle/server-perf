
Vagrant.configure(2) do |config|

  config.vm.box = "petergdoyle/CentOS-7-x86_64-Minimal-1503-01"

  config.vm.network "forwarded_port", guest: 22, host: 5222, host_ip: "0.0.0.0", id: "ssh", auto_correct: true

  config.vm.network "forwarded_port", guest: 5000, host: 15000, host_ip: "0.0.0.0", id: "nginx http server", auto_correct: true
  config.vm.network "forwarded_port", guest: 5010, host: 15010, host_ip: "0.0.0.0", id: "apache http server", auto_correct: true
  config.vm.network "forwarded_port", guest: 5020, host: 15020, host_ip: "0.0.0.0", id: "nodejs http server", auto_correct: true

  config.vm.network "forwarded_port", guest: 5040, host: 15040, host_ip: "0.0.0.0", id: "tomcat http server", auto_correct: true
  config.vm.network "forwarded_port", guest: 5050, host: 15050, host_ip: "0.0.0.0", id: "jetty http server", auto_correct: true
  config.vm.network "forwarded_port", guest: 5060, host: 15060, host_ip: "0.0.0.0", id: "netty http server", auto_correct: true
  config.vm.network "forwarded_port", guest: 5070, host: 15070, host_ip: "0.0.0.0", id: "spring-boot http jetty server", auto_correct: true
  config.vm.network "forwarded_port", guest: 5080, host: 15080, host_ip: "0.0.0.0", id: "spring-boot tomcat jetty server", auto_correct: true


  config.vm.network "forwarded_port", guest: 4200, host: 14200, host_ip: "0.0.0.0", id: "node monitor-dashboard port", auto_correct: true
  config.vm.network "forwarded_port", guest: 3000, host: 13000, host_ip: "0.0.0.0", id: "jmx remote port", auto_correct: true
  config.vm.network "forwarded_port", guest: 9840, host: 19840, host_ip: "0.0.0.0", id: "jmx rmiRegistryPortPlatform", auto_correct: true
  config.vm.network "forwarded_port", guest: 9841, host: 19841, host_ip: "0.0.0.0", id: "jmx rmiServerPortPlatform port", auto_correct: true

  config.vm.provision "file", source: "./README.md", destination: "/home/vagrant/README.md"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
    vb.cpus=2 #recommended=4 if available
    vb.memory = "1024" #recommended=3072 or 4096 if available
  end

  config.vm.provision "shell", inline: <<-SHELL

  # Global Proxy Settings
#  export HTTP_PROXY=http://myproxy.net:80 HTTPS_PROXY=$HTTP_PROXY http_proxy=$HTTP_PROXY https_proxy=$HTTP_PROXY
#  echo "proxy=$HTTP_PROXY" >> /etc/yum.conf
#  cat >/etc/profile.d/proxy.sh <<-EOF
#export HTTP_PROXY=$HTTP_PROXY
#export HTTPS_PROXY=$HTTP_PROXY
#export http_proxy=$HTTP_PROXY
#export https_proxy=$HTTP_PROXY
#EOF

  if [ -n "$HTTP_PROXY" ]; then
    curl -I -x $HTTP_PROXY http://google.com
    if [ $? -ne 0 ]; then
      echo "invalid proxy settings. cannot continue"
      exit 1
    fi
  fi

  #best to update the os
  yum -y update
  #install additional tools
  eval 'tree' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  yum -y install vim htop curl wget net-tools tree unzip siege
  fi

  eval 'docker --version' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  #install docker service
  cat >/etc/yum.repos.d/docker.repo <<-EOF
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
  yum -y install docker
  systemctl start docker.service
  systemctl enable docker.service

  #allow non-#access to run docker commands for user vagrant
  #if you have problems running docker as the vagrant user on the vm (if you 'vagrant ssh'd in
  #after a 'vagrant up'), then
  #restart the host machine and ssh in again to the vm 'vagrant halt; vagrant up; vagrant ssh'
  groupadd docker
  usermod -aG docker vagrant

  #install docker-compose.
  #Compose is a tool for defining and running multi-container applications with Docker.
  yum -y install python-pip
  pip install -U docker-compose
  else
    echo -e "\e[30;48;5;82m docker already appears to be installed. skipping.\e[0m"
  fi

  eval $'node --version' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  #install node.js and npm
  yum -y install epel-release gcc gcc-c++ \
  && yum -y install nodejs npm

  # NPM Proxy Settings
  #npm config set proxy $HTTP_PROXY
  #vnpm config set https-proxy $HTTP_PROXY
  #useful node.js packages

  npm install format-json-stream -g
  npm install lorem-ipsum -g
  npm install forever -g
  npm install monitor-dashboard -g

  else
    echo -e "\e[30;48;5;82m node, npm, npm-libs already appear to be installed. skipping. \e[0m"
  fi


  eval 'java -version' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  mkdir -p /usr/java
  #install java jdk 8 from oracle
  curl -O -L --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
  "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.tar.gz" \
    && tar -xvf jdk-8u60-linux-x64.tar.gz -C /usr/java \
    && ln -s /usr/java/jdk1.8.0_60/ /usr/java/default \
    && rm -f jdk-8u60-linux-x64.tar.gz

  alternatives --install "/usr/bin/java" "java" "/usr/java/default/bin/java" 99999; \
  alternatives --install "/usr/bin/javac" "javac" "/usr/java/default/bin/javac" 99999; \
  alternatives --install "/usr/bin/javaws" "javaws" "/usr/java/default/bin/javaws" 99999

  export JAVA_HOME=/usr/java/default
  cat >/etc/profile.d/java.sh <<-EOF
export JAVA_HOME=$JAVA_HOME
EOF

  #continue setup the remote jmx monitoring security - JAVA_OPTS specifies the port - NOTE This means only 1 jvm can be running at a time
#  cat >/usr/java/default/jre/lib/management/jmxremote.password <<-EOF
#monitorRole  QED
#controlRole   R&D
#EOF

#  chmod 600 /usr/java/jdk1.8.0_60/jre/lib/management/jmxremote.password

  else
    echo -e "\e[30;48;5;82m java already appears to be installed. skipping. \e[0m"
  fi


  eval 'mvn -version' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  mkdir /usr/maven
  #install maven
  curl -O http://www.eu.apache.org/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz \
    && tar -xvf apache-maven-3.3.3-bin.tar.gz -C /usr/maven \
    && ln -s /usr/maven/apache-maven-3.3.3 /usr/maven/default \
    && rm -f apache-maven-3.3.3-bin.tar.gz

  alternatives --install "/usr/bin/mvn" "mvn" "/usr/maven/default/bin/mvn" 99999

  export MAVEN_HOME=/usr/maven/default
  cat >/etc/profile.d/maven.sh <<-EOF
export MAVEN_HOME=$MAVEN_HOME
EOF

  else
    echo -e "\e[30;48;5;82m maven already appears to be installed. skipping. \e[0m"
  fi


  eval '/usr/tomcat/default/bin/catalina.sh version' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  mkdir -p /usr/tomcat
  curl -O http://www.eu.apache.org/dist/tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28.tar.gz \
    && tar -xvf apache-tomcat-8.0.28.tar.gz -C /usr/tomcat \
    && ln -s /usr/tomcat/apache-tomcat-8.0.28 /usr/tomcat/default \
    && rm -f apache-tomcat-8.0.28.tar.gz

    #replace the default port with the port designated for tomcat
    sed -i.bak 's/8080/5040/' /usr/tomcat/default/conf/server.xml
    sed -i.bak1 's/8443/5443/' /usr/tomcat/default/conf/server.xml

    curl -O http://apache.go-parts.com/tomcat/tomcat-8/v8.0.28/bin/extras/catalina-jmx-remote.jar \
      && mv catalina-jmx-remote.jar /usr/tomcat/default/lib/

  export TOMCAT_HOME=/usr/tomcat/default
  cat >/etc/profile.d/tomcat.sh <<-EOF
export TOMCAT_HOME=$TOMCAT_HOME
EOF

    groupadd tomcat
    usermod -aG tomcat vagrant
    chown -R vagrant.tomcat /usr/tomcat/
    chmod -R g+s /usr/tomcat/

  else
    echo -e "\e[30;48;5;82m tomcat already appears to be installed. skipping. \e[0m"
  fi



  if [ ! -d "/usr/jetty/default" ]; then
  mkdir -p /usr/jetty
  curl -O http://download.eclipse.org/jetty/stable-9/dist/jetty-distribution-9.3.5.v20151012.tar.gz \
    && tar -xvf jetty-distribution-9.3.5.v20151012.tar.gz -C /usr/jetty \
    && ln -s /usr/jetty/jetty-distribution-9.3.5.v20151012/ /usr/jetty/default \
    && rm -f jetty-distribution-9.3.5.v20151012.tar.gz

  export JETTY_HOME=/usr/jetty/default
  cat >/etc/profile.d/jetty.sh <<-EOF
export JETTY_HOME=$JETTY_HOME
export JETTY_ARGS="jetty.http.port=5050 jetty.ssl.port=5440"
EOF

    groupadd jetty
    usermod -aG jetty vagrant
    chmod -R vagrant.jetty /usr/jetty/
    chmod -R g+s /usr/jetty/

  else
    echo -e "\e[30;48;5;82m jetty already appears to be installed. skipping. \e[0m"
  fi



  if [ ! -d "/usr/netty/default" ]; then
  mkdir -p /usr/netty
  curl -O -L http://dl.bintray.com/netty/downloads/netty-4.0.33.Final.tar.bz2 \
    && tar -xvf netty-4.0.33.Final.tar.bz2 -C /usr/netty \
    && ln -s /usr/netty/netty-4.0.33.Final/ /usr/netty/default \
    && rm -f netty-4.0.33.Final.tar.bz2

  export NETTY_HOME=/usr/netty/default
  cat >/etc/profile.d/netty.sh <<-EOF
export NETTY_HOME=$NETTY_HOME
EOF

    groupadd netty
    usermod -aG netty vagrant
    chown -R vagrant.netty /usr/netty/
    chmod -R g+s /usr/netty/

  else
    echo -e "\e[30;48;5;82m netty already appears to be downloaded. skipping. \e[0m"
  fi


  eval "httpd -v" > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  yum -y install httpd php

  #replace the default port with the port designated for apache httpd
  sed -i.bak 's/Listen 80/Listen 5010/' /etc/httpd/conf/httpd.conf

  cat >/var/www/html/info.php <<-EOF
<?php
phpinfo();
?>
EOF

  else
    echo -e "\e[30;48;5;82m httpd already appears to be installed. skipping. \e[0m"
  fi

  eval "nginx -v" > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  yum -y install nginx

  #replace the default port with the port designated for nginx
  sed -i.bak 's/80 default_server/5000 default_server/' /etc/nginx/nginx.conf

  else
    echo -e "\e[30;48;5;82m nginx already appears to be installed. skipping. \e[0m"
  fi


  eval "su - vagrant -c 'spring version'" > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  #install spring boot
  su - vagrant -c 'curl -s get.gvmtool.net | bash'
  su - vagrant -c 'printf "sdkman_auto_answer=true" > /home/vagrant/.sdkman/etc/config'
  su - vagrant -c 'sdk install springboot'
  #su - vagrant -c 'sdk install groovy'     #optional
  #su - vagrant -c 'sdk install grails'     #optional
  else
    echo -e "\e[30;48;5;82m springboot already appears to be installed. skipping. \e[0m"
  fi


  if [ ! -d "/usr/jmeter/default" ]; then
  mkdir -p /usr/jmeter
  curl -O http://www.eu.apache.org/dist/jmeter/binaries/apache-jmeter-2.13.tgz \
    && tar -xvf apache-jmeter-2.13.tgz -C /usr/jmeter \
    && ln -s /usr/jmeter/apache-jmeter-2.13 /usr/jmeter/default \
    && rm -f apache-jmeter-2.13.tgz

  export JMETER_HOME=/usr/jmeter/default
  cat >/etc/profile.d/jmeter.sh <<-EOF
export JMETER_HOME=$JMETER_HOME
EOF

  else
    echo -e "\e[30;48;5;82m jmeter already appears to be downloaded. skipping. \e[0m"
  fi


  # on the vm host you need to open up some temporary ports on the firewall
  # if you are running on fedora or centos7 this is done with firewalld commands
  #firewall-cmd --add-port=15000/tcp
  #firewall-cmd --add-port=15010/tcp
  #firewall-cmd --add-port=15020/tcp
  #firewall-cmd --add-port=15030/tcp
  #firewall-cmd --add-port=15040/tcp
  #firewall-cmd --add-port=15050/tcp
  #firewall-cmd --add-port=15060/tcp
  #firewall-cmd --add-port=15070/tcp
  #firewall-cmd --add-port=15080/tcp


  #set hostname
  hostnamectl set-hostname server-perf.vbx

  SHELL
end
