class CrestClient
  CREST_API_BASE_URL = 'https://crest-tq.eveonline.com'.freeze
  MARKET_ORDER_URL = '/orders/all/'

  def initialize(token)
    @token = token
  end

  def fetch_market_order(region_id, page)
    path = CREST_API_BASE_URL + market_order_url(region_id, page)
    Rails.logger.info("CrestClient Access to #{path}")

    MarketOrderResponse.parse(get_request_to(path), current_page: page)
  end

  def fetch_market_order_by_type_id(region_id, type_id, page)
    path = CREST_API_BASE_URL + market_individual_order_url(region_id, type_id, page)
    Rails.logger.info("CrestClient Access to #{path}")

    MarketOrderResponse.parse(get_request_to(path), current_page: page)
  end

  private

  def build_api_connection
    Faraday.new(url: CREST_API_BASE_URL) do |builder|
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
    '/market/' + region_id.to_s + MARKET_ORDER_URL + "?page=#{page}"
  end

  def market_individual_order_url(region_id, type_id, page)
    '/market/' + region_id.to_s + '/orders/?type=https://crest-tq.eveonline.com/inventory/types/' + type_id.to_s + '/'
  end

end
