node :totalCount do
  @managements.total_count
end

child @managements => :results do
  collection @managements

  attributes :id, :character_id, :character_name, :main_character_id, :main_character_name,
    :corporation_id, :corporation_name, :corp_role, :token_verify, :character_birthday,
    :manage_corporation_id, :created_at, :updated_at

  child :main_user => :main_user do
    attribute :uid, :name
  end

  child :corporation do
    attribute :corporation_id, :corporation_name
  end

  child :management_corporation => :management_corporation do
    attribute :corporation_id, :corporation_name
  end

end

node(:api_manager) { current_user.has_api_manager_role? }
node(:recruit) { current_user.has_recruit_role? }
