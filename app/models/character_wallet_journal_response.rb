class CharacterWalletJournalResponse
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  attr_accessor *%i(
    is_success status error items total_page total_count current_page next has_next_page
  )

  def self.parse(response, current_page: 1)
    new.tap do |r|
      body = JSON.parse(response.body)
      header = response.headers

      r.is_success = response.success?
      r.status = response.status
      if response.status != 200 && response.status != 304
        r.error = body['error']
      else
        r.total_page = header['x-pages'].to_i if header['x-pages'].present?
        if current_page < r.total_page
          r.has_next_page = true
        else
          r.has_next_page = false
        end
        r.current_page = current_page
        r.items = body.map { |v| HashObject.new(v) }
      end
    end
  end
end
