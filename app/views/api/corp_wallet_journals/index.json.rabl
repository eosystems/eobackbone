node :totalCount do
  @journals.total_count
end

child @journals => :results do
  collection @journals

  attributes :id, :i_date, :ref_id, :ref_type_id,:ref_type_name, :owner_name1, :owner_name2, :arg_name1,
    :amount, :balance, :reason, :corporation_id,
    :corp_wallet_division_id,
    :created_at, :updated_at
  node(:corporation_name) { |v| v.journal_corporation_name }
end
