class ApiKeyInfoResponse
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  attr_accessor *%i(
    is_success items
  )

  def self.parse(response)
    new.tap do |r|
      r.is_success = response.success?
      results = Hash.from_xml(response.body)["eveapi"]["result"]
      r.items = results.map { |v| HashObject.new(Hash[v[0], v[1]]) }
    end
  end
end
