class EveClient
  XML_API_BASE_URL = 'https://api.eveonline.com'.freeze
  API_KEY_INFO_URL = '/eve/account/APIKeyInfo.xml.aspx'.freeze
  ACCOUNT_STATUS_URL = '/eve/account/AccountStatus.xml.aspx'.freeze
  CORP_WALLET_JOURNAL_URL = '/corp/WalletJournal.xml.aspx'.freeze

  def initialize(key_id, v_code)
    @key_id = key_id
    @v_code = v_code
  end

  def fetch_api_key_info
    XmlApiResponse.parse(get_request_to(API_KEY_INFO_URL))
  end

  def fetch_account_status
    XmlApiResponse.parse(get_request_to(ACCOUNT_STATUS_URL))
  end

  def fetch_corp_wallet_journals(account_key: 1000, from_id: 0)
    XmlApiResponse.parse(get_corp_request_to(CORP_WALLET_JOURNAL_URL, account_key, from_id))
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

  def get_corp_request_to(path, account_key, from_id)
    conn = build_api_connection
    conn.get do |req|
      req.url path
      req.params['keyID'] = @key_id
      req.params['vCode'] = @v_code
      req.params['accountKey'] = account_key
      req.params['fromID'] = from_id
      req.params['rowCount'] = 2560
      Rails.logger.info("Eve Client Access to " + conn.url_prefix.to_s + req.path.to_s + " | key_id: " + @key_id)
    end
  end



end
