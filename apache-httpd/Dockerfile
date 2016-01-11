
FROM server-perf/base 

#install necessary tools and services
RUN yum -y install supervisor httpd php

copy php/ /var/www/html/php/

COPY httpd.conf /etc/httpd/conf/httpd.conf

CMD /usr/sbin/httpd -d /var/www/html -f /etc/httpd/conf/httpd.conf -e info -DFOREGROUND
