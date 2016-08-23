node :totalCount do
  #@departments.total_count
end

child @departments => :results do
  collection @departments

  attributes :id, :department_name, :buy_percentage, :created_at, :updated_at
end
