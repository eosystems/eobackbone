class DivisionResponse
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  attr_accessor *%i(
    is_success items total_page total_count current_page next has_next_page
  )

  def self.parse(response)
    new.tap do |r|
      body = JSON.parse(response.body)
      header = response.headers

      r.is_success = response.success?

      if r.is_success
        r.items = body.map { |v| HashObject.new(v) }
      end
    end
  end
end
