#Server-Perf

##Test Environment

####CPU Info (identical engine1, engine2) 

	CPU Benchmark: 7011 http://www.cpubenchmark.net/cpu.php?cpu=Intel+Xeon+E3-1225+v3+%40+3.20GHz 
    processor	: 0,1,2,3 Quad Core 
    vendor_id	: GenuineIntel
    cpu family	: 6
    model		: 60
    model name	: Intel(R) Xeon(R) CPU E3-1225 v3 @ 3.20GHz
    cpu MHz		: 3200.125
    cache size	: 8192 KB
    siblings	: 4
    cpu cores	: 4

###Virtual Machine (VirtualBox managed by Vagrant)

####Vagrantfile (engine1)
```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  
  config.vm.box = "petergdoyle/CentOS-7-x86_64-Minimal-1503-01"
  
  config.vm.network "forwarded_port", guest: 22, host: 50022, host_ip: "0.0.0.0", id: "ssh", aut
o_correct: true
  config.vm.network "forwarded_port", guest: 5001, host: 15001, host_ip: "0.0.0.0", id: "iperf s
erver port", auto_correct: true

  config.vm.network "public_network", ip: "192.168.1.170"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
    vb.cpus=2
    vb.memory = "2048"
  end
  
  config.vm.provision "shell", inline: <<-SHELL

  yum update -y
  yum -y epel-release 
  yum -y install iperf install htop vim net-tools httpd-tools siege  

  hostnamectl set-hostname engine1perf.vbx

  SHELL
end
```


####Vagrantfile (engine2)
```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  
  config.vm.box = "petergdoyle/CentOS-7-x86_64-Minimal-1503-01"
  
  config.vm.network "forwarded_port", guest: 22, host: 50022, host_ip: "0.0.0.0", id: "ssh", aut
o_correct: true
  config.vm.network "forwarded_port", guest: 5001, host: 15001, host_ip: "0.0.0.0", id: "iperf s
erver port", auto_correct: true

  config.vm.network "public_network", ip: "192.168.1.180"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
    vb.cpus=2
    vb.memory = "2048"
  end
  
  config.vm.provision "shell", inline: <<-SHELL

  yum update -y
  yum -y epel-release 
  yum -y install iperf install htop vim net-tools httpd-tools siege  

  hostnamectl set-hostname engine2perf.vbx

  SHELL
end
```

###Container (Docker) using public docker image 
```ruby
FROM petergdoyle/centos:7
MAINTAINER peter.g.doyle@gmail.com

#install necessary tools and services 
RUN yum -y install vim net-tools tree bash-completion iperf

#EXPOSE 5001

CMD /bin/bash

```

####Docker run commands
iperf Client 
```bash
docker run --rm -ti -h iperfclient --name iperf_client petergdoyle/iperf iperf -c iperf_server
```

iperf Server
```bash
docker run --rm -ti -p 0.0.0.0:15001:5001 -h iperfserver --name iperf_server petergdoyle/iperf iperf -s
```





##Network Speed 

### Physical to Physical
Runs at the same speed as physical to physical - limited by network hardware 
engine1 -> engine2
```bash
[peter@engine1 ~]$ sudo iperf -s
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.1.80 port 5001 connected with 192.168.1.81 port 56026
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-10.0 sec  1.09 GBytes   934 Mbits/sec
[peter@engine1 ~]$ iperf -c engine2
------------------------------------------------------------
Client connecting to engine2, TCP port 5001
TCP window size: 22.5 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.80 port 46625 connected with 192.168.1.81 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  1.09 GBytes   935 Mbits/sec

```

Runs at the same speed as physical to physical - limited by network hardware 
engine2 -> engine1

```bash
[peter@engine2 ~]$ iperf -c engine1 
------------------------------------------------------------
Client connecting to engine1, TCP port 5001
TCP window size: 22.5 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.81 port 56026 connected with 192.168.1.80 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  1.09 GBytes   935 Mbits/sec

[peter@engine2 ~]$ sudo iperf -s
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.1.81 port 5001 connected with 192.168.1.80 port 46625
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-10.0 sec  1.09 GBytes   934 Mbits/sec

```

###Physical to remote VM
Runs at about 65-75% the speed of physical to physical - limited by virtual network layer
```bash
[peter@engine1 ~]$ sudo iperf -c engine2 -p 15001
------------------------------------------------------------
Client connecting to engine2, TCP port 15001
TCP window size: 22.5 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.80 port 46741 connected with 192.168.1.81 port 15001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec   904 MBytes   758 Mbits/sec
[peter@engine1 ~]$ sudo iperf -c engine2 -p 15001
------------------------------------------------------------
Client connecting to engine2, TCP port 15001
TCP window size: 22.5 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.80 port 46742 connected with 192.168.1.81 port 15001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec   791 MBytes   664 Mbits/sec
```

###Physical to local VM
Runs at about 65-75% the speed of physical to physical - limited by virtual network layer
```bash
[peter@engine2 iperf]$ sudo iperf -c localhost -p 15001
------------------------------------------------------------
Client connecting to localhost, TCP port 15001
TCP window size:  648 KByte (default)
------------------------------------------------------------
[  3] local 127.0.0.1 port 50478 connected with 127.0.0.1 port 15001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.5 sec   837 MBytes   668 Mbits/sec
[peter@engine2 iperf]$ sudo iperf -c localhost -p 15001
------------------------------------------------------------
Client connecting to localhost, TCP port 15001
TCP window size:  648 KByte (default)
------------------------------------------------------------
[  3] local 127.0.0.1 port 50479 connected with 127.0.0.1 port 15001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec   809 MBytes   678 Mbits/sec
[peter@engine2 iperf]$ 
```

###Physical to remote Container
Runs at the same speed as physical to physical - limited by network hardware 
```bash
[peter@engine1 ~]$ sudo iperf -c engine2 -p 15001
------------------------------------------------------------
Client connecting to engine2, TCP port 15001
TCP window size: 22.5 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.80 port 46738 connected with 192.168.1.81 port 15001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  1.09 GBytes   935 Mbits/sec
```

###VM to VM (intra-vm)
private networking is about 1 1/2 times the physical network speed (nothing compared to Container to Container speed)
```bash
[vagrant@engine1perftest2 ~]$ iperf -c 192.168.50.11
------------------------------------------------------------
Client connecting to 192.168.50.11, TCP port 5001
TCP window size: 22.5 KByte (default)
------------------------------------------------------------
[  3] local 192.168.50.12 port 49957 connected with 192.168.50.11 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  1.79 GBytes  1.54 Gbits/sec

[vagrant@engine1perftest1 ~]$ iperf -s
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  4] local 192.168.50.11 port 5001 connected with 192.168.50.12 port 49957
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-10.0 sec  1.79 GBytes  1.54 Gbits/sec
```

###Container to Container (intra-container)
Runs at 50 times the speed of network hardware 
```bash
[peter@engine2 iperf]$ client/docker_run.sh 
------------------------------------------------------------
Client connecting to iperf_server, TCP port 5001
TCP window size: 22.5 KByte (default)
------------------------------------------------------------
[  3] local 172.17.0.17 port 57902 connected with 172.17.0.16 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  58.1 GBytes  49.9 Gbits/sec
```

###Container to Container(remote containers)
Runs at the same speed as physical to physical - limited by network hardware 
```bash
[peter@engine2 iperf]$ client/docker_run_remote_container.sh 
------------------------------------------------------------
Client connecting to 192.168.1.80, TCP port 15001
TCP window size: 22.5 KByte (default)
------------------------------------------------------------
[  3] local 172.17.0.9 port 45177 connected with 192.168.1.80 port 15001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  1.09 GBytes   937 Mbits/sec
```