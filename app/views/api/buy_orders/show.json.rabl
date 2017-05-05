object false

child @order => :results do
  attributes :id, :total_price, :sell_price, :total_volume,
    :is_credit, :is_paid, :processing_status, :station_id, :order_by, :assigned_user_id,
    :corporation_id, :note, :created_at, :updated_at,
    :total_estimate_sell_price, :total_estimate_buy_price, :done_date, :estimate_date

  node(:order_user_name) { |v| v.order_user.try(:name) }
  node(:contract_station_name) { |v| v.contract_station_name }
  node(:department_name) { |v| v.department.try(:department_name) }

  child :order_details do
    attributes :item_id, :unit_price,
      :sell_unit_price, :quantity, :image_path, :price, :volume, :sell_price,
      :pre_sell_unit_price, :pre_buy_unit_price, :pre_quantity
    node(:item_name) { |o| o.item_type_name }
  end

  node(:management_accept) { |o| o.can_change_to_accept_for_buy?(current_user) }
  node(:management_reject) { |o| o.can_change_to_reject_for_buy?(current_user) }
  node(:management_undo) { |o| o.can_change_to_undo?(current_user) }
  node(:management_create_contract) { |o| o.can_create_contract?(current_user) }
  node(:management_delete) { |o| o.can_change_to_delete?(current_user) }
end
