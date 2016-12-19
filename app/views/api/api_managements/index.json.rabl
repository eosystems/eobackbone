node :totalCount do
  @managements.total_count
end

child @managements => :results do
  collection @managements

  attributes :id, :key_id, :v_code, :character_id, :corporation_id, :alliance_id, :access_mask, :alpha, :full_api,
    :expires, :api_manage_corporation_id, :created_at, :updated_at

  child :user do
    attribute :uid, :name
  end

  child :main_user do
    attribute :uid, :name
  end

  child :corporation do
    attribute :corporation_id, :corporation_name
  end

end
