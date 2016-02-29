
FROM server-perf/base

RUN yum -y install golang

COPY server-perf-go/bin/ /go/bin/

WORKDIR /go/

CMD /bin/bash
