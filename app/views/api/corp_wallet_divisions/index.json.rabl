node :totalCount do
  @divisions.total_count
end

child @divisions => :results do
  collection @divisions

  attributes :id, :account_key, :name, :corporation_id,
    :created_at, :updated_at
  node(:corporation_name) { |v| v.division_corporation_name }
end
