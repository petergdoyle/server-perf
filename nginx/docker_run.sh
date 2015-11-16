#!/usr/bin/env bash

docker run -d -p 0.0.0.0:5000:80 -h nginx.dkr --name nginx_http server-perf/nginx_http  \
nginx -g "daemon off;"
