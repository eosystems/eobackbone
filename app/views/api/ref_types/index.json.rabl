child @types => :results do
  collection @types

  attributes :id, :name

  node(:title) { |v| v.name }
end
