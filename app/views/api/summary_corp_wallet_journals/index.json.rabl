node :totalCount do
  #@summary_journals.total_count
end

child @summary_journals => :results do
  attributes :ref_type_id, :ref_type_name, :amount
end
