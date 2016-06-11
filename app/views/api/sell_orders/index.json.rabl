object false

child(@order => :result) do
  attributes :total_price

  child :order_details do
    attributes :raw_item_name, :item_id, :unit_price, :quantity, :image_path, :price, :volume
    node(:item_name) { |o| o.raw_item_name }
  end
end
