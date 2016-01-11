
FROM server-perf/base

RUN yum -y install epel-release gcc gcc-c++ \
  && yum -y install nodejs npm \
  && npm install monitor-dashboard -g \
  && npm install strongloop -g

COPY node_modules/ /node/node_modules/
COPY express_server.js /node/express_server.js
COPY http_server.js /node/http_server.js
COPY http_server_clustered.js /node/http_server_clustered.js

WORKDIR /node

#EXPOSE 5020 4200

CMD /bin/bash
