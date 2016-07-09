class Api::TradeSummariesController < ApiController
  def index
    @trades = Trade
      .search_with(params[:filter], params[:sorting], params[:page], params[:count])
      .summary(current_user.id)
      .order(trade_date: :desc)
  end
end
