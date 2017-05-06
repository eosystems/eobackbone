object false

child @order => :results do
  attributes :id, :total_price, :sell_price, :total_volume,
    :is_credit, :is_paid, :processing_status, :station_id, :order_by, :assigned_user_id,
    :corporation_id, :note, :created_at, :updated_at

  node(:order_user_name) { |v| v.order_user.try(:name) }
  node(:contract_station_name) { |v| v.contract_station_name }
  node(:department_name) { |v| v.department.try(:department_name) }

  child :order_details do
    attributes :item_id, :unit_price, :id,
      :sell_unit_price, :quantity, :image_path, :price, :volume, :sell_price
    node(:item_name) { |o| o.item_type_name }
  end

  node(:management_done) { |o| o.can_change_to_done?(current_user) }
  node(:management_cancel) { |o| o.can_change_to_cancel?(current_user) }
  node(:management_reject) { |o| o.can_change_to_reject?(current_user) }
  node(:management_in_process) { |o| o.can_change_to_in_process?(current_user) }
end
