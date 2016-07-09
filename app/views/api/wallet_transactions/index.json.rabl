node :totalCount do
  @transactions.total_count
end

child @transactions => :results do
  collection @transactions

  attributes :id, :transaction_date, :transaction_id, :type_id, :price, :client_name, :station_id,
    :quantity, :station_name, :transaction_type, :transaction_for, :trade,:image_path,
     :created_at, :updated_at

  node(:item_name) { |o| o.item_type_name }
end
