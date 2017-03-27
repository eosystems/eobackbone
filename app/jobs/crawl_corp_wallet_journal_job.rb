class CrawlCorpWalletJournalJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Rails.logger.info("start crawl corp wallet journal")
    CorpWalletJournal.new.import_all_corporation_journals
    Rails.logger.info("end crawl corp wallet journal")
  end
end
