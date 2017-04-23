FROM ruby:2.3

RUN mkdir -p /var/www/eobackbone/current
WORKDIR /var/www/eobackbone

RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN apt-get supervisor
COPY supervisord.conf /etc/
COPY Gemfile /var/www/eobackbone/current
COPY Gemfile.lock /var/www/eobackbone/current

ENV RAILS_VERSION 5.0.1
RUN gem install rails --version "$RAILS_VERSION"
RUN bundle install --without development test

EXPOSE 8080
