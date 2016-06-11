class MarketOrderResponse
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
      r.total_page = body['pageCount'].to_i if body['pageCount'].present?
      r.total_count = body['totalCount'].to_i if body['totalCount'].present?
      if body['next'].present?
        r.has_next_page = true
        r.next = body['next']['href'].to_s
      else
        r.has_next_page = false
      end
      r.current_page = current_page
      r.items = if body['items'].present?
                  body['items'].map { |v| HashObject.new(v) }
                else
                  []
                end
    end
  end
end
