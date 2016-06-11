node :totalCount do
  @orders.total_count
end

child @orders => :results do
  collection @orders

  attributes :id, :total_price, :sell_price, :total_volume, :processing_status, :order_by,
    :assigned_user_id, :created_at, :updated_at
end
