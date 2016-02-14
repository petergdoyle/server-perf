
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

  #installing the minimum to build things (java and nodejs) and run a docker daemon
  #additional scripts for performance can be found here https://github.com/petergdoyle/devops-scripts/tree/master/bash/centos/vagrant/perf-pack
  #additional server/framwork installation scripts can be found here https://github.com/petergdoyle/devops-scripts/tree/master/bash/centos/vagrant


  #best to update the os
  yum -y update
  #install additional tools
  yum -y install vim htop curl wget tree unzip telnet

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
    echo -e "\e[7;40;92mdocker already appears to be installed. skipping.\e[0m"
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

  npm install monitor-dashboard -g

  else
    echo -e "\e[7;40;92mnode, npm, npm-libs already appear to be installed. skipping.\e[0m"
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
    echo -e "\e[7;40;92mjava already appears to be installed. skipping.\e[0m"
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
    echo -e "\e[7;40;92mmaven already appears to be installed. skipping.\e[0m"
  fi


  #curl -s https://raw.githubusercontent.com/petergdoyle/devops-scripts/master/bash/centos/vagrant/tomcat_8_tar_install.sh |bash -s

  #curl -s https://raw.githubusercontent.com/petergdoyle/devops-scripts/master/bash/centos/vagrant/jetty_9_tar_install.sh |bash -s

  #curl -s https://raw.githubusercontent.com/petergdoyle/devops-scripts/master/bash/centos/vagrant/httpd%2Bphp_latest_yum_install.sh |bash -s

  #curl -s https://raw.githubusercontent.com/petergdoyle/devops-scripts/master/bash/centos/vagrant/nginx_latest_yum_install.sh |bash -s

  #curl -s https://raw.githubusercontent.com/petergdoyle/devops-scripts/master/bash/centos/vagrant/springboot_latest_sdkman_install.sh |bash -s


#
# additional performance / stress / load test tools
#

  #curl -s https://raw.githubusercontent.com/petergdoyle/devops-scripts/master/bash/centos/vagrant/perf-pack/os_perf_utils.sh |bash -s

  #curl -s https://raw.githubusercontent.com/petergdoyle/devops-scripts/master/bash/centos/vagrant/perf-pack/autobench_latest_make_install.sh |bash -s

  #curl -s https://raw.githubusercontent.com/petergdoyle/devops-scripts/master/bash/centos/vagrant/perf-pack/curl-loader_latest_make_install.sh |bash -s

  #curl -s https://raw.githubusercontent.com/petergdoyle/devops-scripts/master/bash/centos/vagrant/perf-pack/install_httperf_rpm.sh |bash -s

  #curl -s https://raw.githubusercontent.com/petergdoyle/devops-scripts/master/bash/centos/vagrant/perf-pack/jmeter_2_tar_install.sh |bash -s

  # on the vm host you need to open up some temporary ports on the firewall
  # if you are running on fedora or centos7 this is done with firewalld commands
  firewall-cmd --add-port=20000-29999/tcp

  #set hostname
  hostnamectl set-hostname server-perf.vbx

  SHELL
end
