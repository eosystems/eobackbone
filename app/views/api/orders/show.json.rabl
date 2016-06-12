object false

child @order => :results do
  attributes :total_price
  attributes :sell_price
  attributes :total_volume

  child :order_details do
    attributes :item_id, :unit_price,
      :sell_unit_price, :quantity, :image_path, :price, :volume, :sell_price
    node(:item_name) { |o| o.item_type_name }
  end
end
