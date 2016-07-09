class Api::TradeHistorySummariesController < ApiController
  def index
    @trades = Trade
      .search_with(params[:filter], params[:sorting], params[:page], params[:count])
      .summary_one_day(current_user.id)
      .order(trade_date: :desc)
  end
end
