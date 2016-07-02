object false

child @order => :results do
  attributes :id, :order_id, :user_id, :station_id, :type_id, :price, :buy, :issued, :order_state,
     :volume_remain, :volume_entered, :duration,
     :created_at, :updated_at

  node(:item_name) { |v| v.item_type_name }
  node(:order_station_name) { |v| v.order_station_name }

  child :monitor_market_orders do
    node(:price) { |v| v.price }
    node(:quantity) { |v| v.volume }
    node(:order_id) { |v| v.order_id }
  end

end
