namespace :eobackbone do
  namespace :workflow do
    desc "corp wallet journal"
    task :crawl_corp_wallet_journal do
      sh "bundle exec rails runner 'CrawlCorpWalletJournalJob.perform_later'"
    end
  end
end
