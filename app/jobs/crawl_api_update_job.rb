class CrawlApiUpdateJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Rails.logger.info("start api update job")
    ApiManagement.all_api_update
    Rails.logger.info("end api update job")
  end

end
