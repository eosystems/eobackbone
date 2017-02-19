class CrawlRefTypesJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Rails.logger.info("start crawl ref types")
    Rails.logger.info("end crawl ref types")
  end

end
