node :totalCount do
  @roles.total_count
end

child @roles => :results do
  collection @managements

  attributes :id, :role_user_name, :operation_role_name, :user_id, :role
end

node(:manager) { current_user.has_manager_role? }
