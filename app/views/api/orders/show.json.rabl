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

  node(:management_done) { |o| o.can_change_to_done?(current_user) }
  node(:management_cancel) { |o| o.can_change_to_cancel?(current_user) }
  node(:management_reject) { |o| o.can_change_to_reject?(current_user) }
  node(:management_in_process) { |o| o.can_change_to_in_process?(current_user) }
end
