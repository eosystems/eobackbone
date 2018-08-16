FROM ruby:2.3

RUN mkdir -p /var/www/
WORKDIR /var/www/

RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y cron rsyslog supervisor vim locales locales-all --no-install-recommends
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# timezone
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

ENV RAILS_VERSION 5.1
RUN gem install rails --version "$RAILS_VERSION"

RUN rails new eobackbone_kuroko --database=mysql --skip-turbolinks --skip-javascript -m https://raw.githubusercontent.com/cookpad/kuroko2/master/app_template.rb
WORKDIR /var/www/eobackbone_kuroko
RUN bundle install
COPY ./database.yml.example config/database.yml
COPY Procfile Procfile

CMD ["foreman", "start"]
