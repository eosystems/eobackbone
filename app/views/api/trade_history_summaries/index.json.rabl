node :totalCount do
  @trades.total_count
end

child @trades => :results do
  collection @trades

  attributes :id, :trade_date,
    :sales, :cost, :tax, :expense, :profit, :inventory_valuation,
    :created_at, :updated_at
end
