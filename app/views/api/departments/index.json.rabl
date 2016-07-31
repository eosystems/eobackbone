node :totalCount do
  #@departments.total_count
end

child @departments => :results do
  collection @departments

  attributes :id, :department_name, :created_at, :updated_at
end
