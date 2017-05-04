#!/bin/bash -x
cd /var/www/eobackbone/current
bundle exec rake db:migrate RAILS_ENV=production
bundle exec rake assets:precompile RAILS_ENV=production
buddle exec rake assets:clean RAILS_ENV=production
bundle exec unicorn_rails -c config/unicorn.rb -E production -D
tools/delayed_job_crawler.sh -e production start
