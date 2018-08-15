node :totalCount do
  @applications.total_count
end

child @applications => :results do
  collection @applications

  attributes :id, :targetable_type, :targetable_id, :processing_status, :application_user_name, :process_user_name, :target_type_name,
    :corporation_name, :application_name,
    :done_date, :created_at, :updated_at

  node(:management_done) { |o| o.can_change_to_done?(current_user) }
  node(:management_cancel) { |o| o.can_change_to_cancel?(current_user) }
  node(:management_reject) { |o| o.can_change_to_reject?(current_user) }
end
