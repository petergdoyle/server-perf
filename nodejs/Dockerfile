
FROM petergdoyle/centos:7

RUN yum -y install supervisor sysstat htop
RUN yum -y install epel-release gcc gcc-c++ \
&& yum -y install nodejs npm \
&& npm install monitor-dashboard -g

ENV DOCKER_VOL /docker
ENV NODE_ENV external

WORKDIR $DOCKER_VOL

EXPOSE 5020 4200
