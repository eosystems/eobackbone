class EsiClient
  ESI_API_BASE_URL = 'https://esi.evetech.net/latest'.freeze

  def initialize(token)
    @token = token
  end

  def fetch_market_order(region_id, page)
    path = ESI_API_BASE_URL + market_order_url(region_id, page)
    Rails.logger.info("ESIClient Access to #{path}")

    MarketOrderResponse.parse(get_request_to(path), current_page: page)
  end

  def fetch_division(corporation_id)
    path = ESI_API_BASE_URL + "/corporations/#{corporation_id}/divisions/"
    Rails.logger.info("ESIClient Access to #{path}")

    DivisionResponse.parse(get_request_to(path))
  end

  private

  def build_api_connection
    Faraday.new(url: ESI_API_BASE_URL) do |builder|
      builder.request :url_encoded
      builder.adapter Faraday.default_adapter
    end
  end

  def get_request_to(path)
    conn = build_api_connection
    conn.get do |req|
      req.url path
    end
  end

  def market_order_url(region_id, page)
    '/markets/' + region_id.to_s + "/orders/?datasource=tranquility&page=#{page}&order_type=all"
  end

end
