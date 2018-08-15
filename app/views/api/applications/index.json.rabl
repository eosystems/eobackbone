node :totalCount do
  @applications.total_count
end

child @applications => :results do
  collection @applications

  attributes :id, :targetable_type, :targetable_id, :processing_status, :application_user_name, :process_user_name, :target_type_name,
    :corporation_name, :application_name,
    :done_date, :created_at, :updated_at
end
