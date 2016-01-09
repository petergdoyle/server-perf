
Vagrant.configure(2) do |config|

  config.vm.box = "petergdoyle/CentOS-7-x86_64-Minimal-1503-01"

  config.vm.network "forwarded_port", guest: 22, host: 5222, host_ip: "0.0.0.0", id: "ssh", auto_correct: true

  # by convention the servers will run on specific ports in the 5000-6000 range
  # if running in docker "host" networking mode then those ports will be exposed directly from the host network interface
  # if running in docker on "port-forwarded" networking mode, then those ports use the same port +10000
  # - NOTE: port-forwarded ports do not need to be exposed individually by a firewall because by default docker exposes them all on its docker0 interface
  # if running in a vm (vagrant), then those server ports will use the same port +20000
  # - NOTE: these ports must be exposed by a firewall rule
  # if running on the host directly, then the same server ports in the 5000-6000 range will be used (or possibly port-mapped by the host)
  # - NOTE: these ports must be exposed by a firewall rule
  config.vm.network "forwarded_port", guest: 5000, host: 25000, host_ip: "0.0.0.0", id: "nginx static html server", auto_correct: true
  config.vm.network "forwarded_port", guest: 5001, host: 25001, host_ip: "0.0.0.0", id: "nginx http server", auto_correct: true

  config.vm.network "forwarded_port", guest: 5010, host: 25010, host_ip: "0.0.0.0", id: "apache php server", auto_correct: true
  config.vm.network "forwarded_port", guest: 5011, host: 25011, host_ip: "0.0.0.0", id: "apache python server", auto_correct: true
  config.vm.network "forwarded_port", guest: 5012, host: 25012, host_ip: "0.0.0.0", id: "apache static html server", auto_correct: true

  config.vm.network "forwarded_port", guest: 5020, host: 25020, host_ip: "0.0.0.0", id: "nodejs express server", auto_correct: true
  config.vm.network "forwarded_port", guest: 5021, host: 25021, host_ip: "0.0.0.0", id: "nodejs async http server", auto_correct: true
  config.vm.network "forwarded_port", guest: 5022, host: 25022, host_ip: "0.0.0.0", id: "nodejs clustered http server", auto_correct: true

  config.vm.network "forwarded_port", guest: 5040, host: 25040, host_ip: "0.0.0.0", id: "tomcat servlet server", auto_correct: true
  config.vm.network "forwarded_port", guest: 5050, host: 25050, host_ip: "0.0.0.0", id: "jetty servlet server", auto_correct: true

  config.vm.network "forwarded_port", guest: 5060, host: 25060, host_ip: "0.0.0.0", id: "netty async http server", auto_correct: true

  config.vm.network "forwarded_port", guest: 5070, host: 25070, host_ip: "0.0.0.0", id: "springboot embedded tomcat", auto_correct: true
  config.vm.network "forwarded_port", guest: 5071, host: 25071, host_ip: "0.0.0.0", id: "springboot embedded jetty", auto_correct: true
  config.vm.network "forwarded_port", guest: 5072, host: 25072, host_ip: "0.0.0.0", id: "springboot embedded undertow", auto_correct: true
  
  config.vm.network "forwarded_port", guest: 5090, host: 25090, host_ip: "0.0.0.0", id: "undertow http server", auto_correct: true

  #
  # ports that run monitoring and profiling services
  #
  config.vm.network "forwarded_port", guest: 4200, host: 24200, host_ip: "0.0.0.0", id: "node monitor-dashboard port", auto_correct: true

  config.vm.network "forwarded_port", guest: 10001, host: 20001, host_ip: "0.0.0.0", id: "jmx rmiRegistryPortPlatform port", auto_correct: true
  config.vm.network "forwarded_port", guest: 10002, host: 20002, host_ip: "0.0.0.0", id: "jmx rmiServerPortPlatform port", auto_correct: true

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
    vb.cpus=2 #recommended=4 if available
    vb.memory = "1024" #recommended=3072 or 4096 if available
  end

  config.vm.provision "shell", inline: <<-SHELL

  # Global Proxy Settings
#  export HTTP_PROXY=http://myproxy.net:80 HTTPS_PROXY=$HTTP_PROXY http_proxy=$HTTP_PROXY https_proxy=$HTTP_PROXY
#  echo "py=$HTTP_PROXY" >> /etc/yum.conf
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
  eval 'iperf' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  yum -y install vim htop curl wget net-tools tree unzip siege telnet iperf
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
  alternatives --install "/usr/bin/javaws" "javaws" "/usr/java/default/bin/javaws" 99999; \
  alternatives --install "/usr/bin/jvisualvm" "jvisualvm" "/usr/java/default/bin/jvisualvm" 99999

  export JAVA_HOME=/usr/java/default
  cat >/etc/profile.d/java.sh <<-EOF
export JAVA_HOME=$JAVA_HOME
EOF

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

#
# additional performance / stress / load test tools
#

# curl-loader
  eval 'curl-loader' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
    mkdir /usr/curl-loader
    curl -L -o curl-loader-0.56.tar.bz2 http://sourceforge.net/projects/curl-loader/files/latest/download?source=files \
    && bunzip2 curl-loader-0.56.tar.bz2 \
    && tar -xvf curl-loader-0.56.tar -C /usr/curl-loader \
    && ln -s /usr/curl-loader/curl-loader-0.56/ /usr/curl-loader/default

    cd /usr/curl-loader/default
    yum -y install make libcurl-devel libevent binutils gcc patch openssl-devel
    make
    if [ $? -ne 0 ]; then
      echo -e "\e[1;31m curl-loader - make did not run successfully. skipping. \e[0m"
    else
      alternatives --install "/usr/bin/curl-loader" "curl-loader" "/usr/curl-loader/default/curl-loader" 99999
    fi
    cd /
    rm -f curl-loader-0.56.tar

  else
    echo -e "\e[30;48;5;82m curl-loader already appears to be downloaded. skipping. \e[0m"
  fi

  #httperf
  if [ ! -d "/usr/httperf/default" ]; then
    curl -L -O http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm \
    && yum -y localinstall rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm \
    && yum -y install httperf \
    && rm -f rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
  else
    echo -e "\e[30;48;5;82m httperf already appears to be downloaded. skipping. \e[0m"
  fi

  eval 'curl-loader' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
    mkdir /usr/autobench
    git clone https://github.com/menavaur/Autobench.git  /usr/autobench
    cd /usr/autobench
    make \
    && make install
    if [ $? -ne 0 ]; then
      echo -e "\e[1;31m curl-loader - make did not run successfully. skipping. \e[0m"
    else
  else
    echo -e "\e[30;48;5;82m autobench already appears to be downloaded. skipping. \e[0m"
  fi


  eval 'cutter' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
    mkdir /usr/cutter
    curl -L -O http://www.digitage.co.uk/digitage/files/cutter/cutter-1.04.tgz
    && tar -xvf cutter-1.04.tgz -C /usr/cutter
    && ln -s /usr/cutter/cutter-1.04/ /usr/cutter/default
    && cd /usr/cutter/default
    && make
    if [ $? -ne 0 ]; then
      echo -e "\e[1;31m cutter - make did not run successfully. skipping. \e[0m"
    else
      alternatives --install "/usr/bin/cutter" "cutter" "/usr/cutter/default/cutter" 99999
    fi
    cd -
    rm -f cutter-1.04.tgz
  else
    echo -e "\e[30;48;5;82m cutter already appears to be downloaded. skipping. \e[0m"
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
