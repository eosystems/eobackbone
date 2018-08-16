namespace :eobackbone do
  namespace :workflow do
    desc "corp wallet journal"
    task :crawl_corp_wallet_journal do
      sh "bundle exec rails runner 'CrawlCorpWalletJournalJob.perform_now'"
    end
    desc "corp_member update"
    task :corp_member_update do
      sh "bundle exec rails runner 'UpdateCorpMemberJob.perform_now'"
    end
  end
end
