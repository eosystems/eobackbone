class CrawlRefTypesJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Rails.logger.info("start crawl ref types")
    client = EveClient.new('dummy','dummy')
    response = client.fetch_ref_types
    items = response.items[0].rowset.row.map{ |v| HashObject.new(v) }

    RefType.delete_all
    items.each do |item|
      r = RefType.new
      r.id = item.refTypeID
      r.name = item.refTypeName
      r.save
    end

    Rails.logger.info("end crawl ref types")
  end

end
