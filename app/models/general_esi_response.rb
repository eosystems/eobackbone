class GeneralEsiResponse
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  attr_accessor *%i(
    is_success items
  )

  def self.parse_simple_array(response)
    new.tap do |r|
      body = JSON.parse(response.body)

      r.is_success = response.success?
      r.current_page = current_page
      r.items = body
    end
  end
end
