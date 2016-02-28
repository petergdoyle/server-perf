
FROM server-perf/base

RUN yum -y install golang

COPY server-perf-go/* /go/
COPY profile /etc/profile 

ENV GOROOT=/usr/local/go
ENV PATH=$PATH:$GOROOT/bin

CMD /bin/bash
