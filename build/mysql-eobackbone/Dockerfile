FROM mysql:5.7.16
RUN apt-get update && apt-get install -y vim locales locales-all --no-install-recommends
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ADD setting/init.sql /docker-entrypoint-initdb.d/
