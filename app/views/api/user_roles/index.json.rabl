node :totalCount do
  @roles.total_count
end

child @roles => :results do
  collection @roles

  attributes :id, :role_user_name, :operation_role_name, :user_id, :role
  node(:corporation_name) { |v| v.user.user_detail.corporation.corporation_name }
end

node(:manager) { current_user.has_manager_role? }
