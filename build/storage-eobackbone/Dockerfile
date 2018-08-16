FROM bash
MAINTAINER chato <quick.xp@gmail.com>

RUN mkdir -p /data/eobackbone
RUN mkdir -p /data/eobackbone/config
RUN mkdir /data/eobackbone/unicorn

WORKDIR /data/eobackbone
VOLUME /data/eobackbone
VOLUME /var/www/eobackbone/current/public
#VOLUME /var/www/eobackbone/current/log

#COPY config/* /data/eobackbone/config/
COPY config/.keep /data/eobackbone/unicorn/

CMD ["/usr/local/bin/bash"]
