class CrawlWalletTransactionJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Rails.logger.info("start crawl wallet transaction")
    users = UserDetail.where.not(key_id: nil)
    users.each do |u|
      WalletTransaction.update(u.user_id)
    end
    Rails.logger.info("end crawl wallet transaction")
  end
end
