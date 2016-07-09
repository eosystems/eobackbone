node :totalCount do
  @trades.total_count
end

child @trades => :results do
  collection @trades

  attributes :id, :trade_date, :type_id, :user_id, :sales_quantity, :sales_average_price,
    :purchase_quantity, :purchase_average_price, :sales, :cost, :tax, :expense, :profit, :inventory_valuation,
    :image_path,
    :created_at, :updated_at

  node(:item_name) { |o| o.item_type_name }
end
