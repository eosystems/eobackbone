node :totalCount do
  @orders.total_count
end

child @orders => :results do
  collection @orders

  attributes :id, :order_id, :user_id, :station_id, :type_id, :price, :buy, :issued, :order_state, :monitor,
     :created_at, :updated_at

  node(:item_name) { |o| o.item_type_name }
  node(:order_station_name) { |v| v.order_station_name }
  node(:lose_or_win) { |o| o.lose_or_win }
end
