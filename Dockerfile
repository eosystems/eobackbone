FROM ruby:2.3

RUN mkdir -p /var/www/eobackbone
WORKDIR /var/www/eobackbone

RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y supervisor vim locales locales-all --no-install-recommends
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
COPY supervisord.conf /etc/

RUN git clone https://github.com/eosystems/eobackbone.git ./current
WORKDIR /var/www/eobackbone/current

ENV RAILS_VERSION 5.0.1
RUN gem install rails --version "$RAILS_VERSION"
RUN bundle install --without development test

ADD .git/index /data/dummy_eobackbone
ARG gitbranch="master"
RUN git fetch
RUN git checkout $gitbranch
RUN git pull origin HEAD
RUN bundle install

RUN rm config/database.yml && ln -s /data/eobackbone/config/database.yml config/database.yml
RUN ln -s /data/eobackbone/config/settings.yml config/settings.yml
RUN rm config/secrets.yml && ln -s /data/eobackbone/config/secrets.yml config/secrets.yml
RUN ./tools/delayed_job_crawler.sh -e production start
RUN bundle exec rake unicorn:start
