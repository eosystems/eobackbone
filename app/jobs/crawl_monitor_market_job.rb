class CrawlMonitorMarketJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    Rails.logger.info("start crawl monitor market orders")

    monitor_items = UserMarketOrder.where(monitor: 1).select(:station_id, :type_id).uniq
    monitor_items.each do | monitor_item |
      region_id = monitor_item.station.region_id
      type_id = monitor_item.type_id

      # 直近で取得していた場合は飛ばす
      j = MonitorMarketOrder.where(station_id: monitor_item.station.station_id, type_id: type_id).first
      if j.nil? || j.updated_at < Time.zone.now - 5.minute
        is_success, items = fetch_market_orders(region_id, type_id)
        if is_success
          save_market_orders(items, region_id, type_id)

          # Userオーダー更新
          update_user_orders(region_id, type_id)
        end
      else
        Rails.logger.warn("skip crawl because " + type_id.to_s + " has updated within 5 minute")
      end
    end

    Rails.logger.info("end crawl monitor market orders")
  end

  def update_user_orders(region_id, type_id)
     StaStation.where(region_id: region_id).each do | station |
      orders = UserMarketOrder.where(station_id: station.station_id, type_id: type_id)
      orders.each do |order|
        market = MonitorMarketOrder.where(order_id: order.order_id).first
        if market.present?
          order.price = market.price
          order.volume_remain = market.volume
          order.save!
        else
          order.volume_remain = 0
          order.save!
        end
      end
    end
  end

  # リポジトリの結果結果を保存
  def save_market_orders(results, region_id, type_id)
    save_results = []

    StaStation.where(region_id: region_id).each do | station |
      MonitorMarketOrder.delete_all(station_id: station.station_id, type_id: type_id)
    end
    count = 0
    results.each do |result|
      r = MonitorMarketOrder.new
      r.attributes = {
        buy: result.buy,
        issued: result.issued,
        price: result.price,
        volume_entered: result.volumeEntered,
        station_id: result.location.id,
        volume: result.volume,
        range: result.range,
        min_volume: result.minVolume,
        duration: result.duration,
        type_id: result.type.id,
        order_id: result.id
      }
      save_results << r
      if count % 1000 == 0
        MarketOrder.import save_results
        save_results = []
      end
      count = count + 1
    end
    MonitorMarketOrder.import save_results
  end

  def fetch_market_orders(region_id, type_id)
    client = CrestClient.new("")
    results = []
    retry_count = 0
    page = 1

    loop do
      res = client.fetch_market_order_by_type_id(region_id, type_id, page)

      total_count ||= res.total_count
      Rails.logger.info("fetch market orders (page: #{page}, total: #{total_count})" \
                        " and results #{res.items.size}")
      if res.items.size == 0 || !res.is_success
        Rails.logger.info("fetch failed. Retry(retry count: #{retry_count})")
        if retry_count >= 5
          fail 'Retry Limit.'
        else
          retry_count += 1
          redo
        end
      else
        retry_count = 0
        results << res.items
        if res.has_next_page
          page += 1
        else
          break
        end

      end

    end

    [true, results.flatten]
  end


end
