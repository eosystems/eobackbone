child @items => :results do
  collection @items

  attributes :id, :amount, :balance, :context_id, :context_id_type, :date, :description, :first_party_id, :secount_party_id, :ref_type

end

node(:has_next_page) { @has_next_page }
node(:api_manager) { current_user.has_api_manager_role? }
node(:recruit) { current_user.has_recruit_role? }
