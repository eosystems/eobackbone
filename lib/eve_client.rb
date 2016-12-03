class EveClient
  XML_API_BASE_URL = 'https://api.eveonline.com/eve'.freeze
  API_KEY_INFO_URL = '/account/APIKeyInfo.xml.aspx'.freeze

  def initialize(key_id, v_code)
    @key_id = key_id
    @v_code = v_code
  end

  def fetch_api_key_info
    ApiKeyInfoResponse.parse(get_request_to(API_KEY_INFO_URL))
  end

  private

  def build_api_connection
    Faraday.new(url: XML_API_BASE_URL) do |builder|
      builder.request :url_encoded
      builder.adapter Faraday.default_adapter
    end
  end

  def get_request_to(path)
    conn = build_api_connection
    conn.get do |req|
      req.url path
      req.params['keyID'] = @key_id
      req.params['vCode'] = @v_code
      Rails.logger.info("Eve Client Access to " + conn.url_prefix.to_s + req.path.to_s + " | key_id: " + @key_id)
    end
  end


end
