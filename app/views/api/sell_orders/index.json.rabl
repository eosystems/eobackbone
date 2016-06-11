object false

child(@order => :result) do
  attributes :total_price
  attributes :sell_price
  attributes :total_volume

  child :order_details do
    attributes :raw_item_name, :item_id, :unit_price,
      :sell_unit_price, :quantity, :image_path, :price, :volume, :sell_price
    node(:item_name) { |o| o.raw_item_name }
  end
end
