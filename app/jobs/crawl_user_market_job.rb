class CrawlUserMarketJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Rails.logger.info("start crawl user market order")
    users = UserDetail.where.not(key_id: nil)
    users.each do |u|
      UserMarketOrder.update(u.user_id)
    end
    Rails.logger.info("end crawl user market order")
  end
end
