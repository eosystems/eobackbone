class UpdateCorpMemberJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Rails.logger.info("start corp member update")
    CorpMember.update_corp_member
    Rails.logger.info("end corp member update")
  end
end
