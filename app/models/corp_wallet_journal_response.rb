class CorpWalletJournalResponse
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  attr_accessor *%i(
    is_success items total_page total_count current_page next has_next_page
  )

  def self.parse(response, current_page: 1)
    new.tap do |r|
      body = JSON.parse(response.body)
      header = response.headers

      r.is_success = response.success?
      r.total_page = header['x-pages'].to_i if header['x-pages'].present?
      #r.total_count = body['totalCount'].to_i if body['totalCount'].present?
      if current_page < r.total_page
        r.has_next_page = true
        #r.next = body['next']['href'].to_s
      else
        r.has_next_page = false
      end
      r.current_page = current_page
      r.items = body.map { |v| HashObject.new(v) }
    end
  end
end
