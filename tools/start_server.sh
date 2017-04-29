#!/bin/bash -x
bundle exec rake db:migrate RAILS_ENV=production
bundle exec unicorn_rails -c config/unicorn.rb -E production -D
./delayed_job_crawler.sh -e production start
