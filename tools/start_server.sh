#!/bin/bash -x
bundle exec rake db:migrate RAILS_ENV=production
bundle exec rake unicorn:start
# ./delayed_job_crawler.sh -e production start
