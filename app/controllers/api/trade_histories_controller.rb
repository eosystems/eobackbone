class Api::TradeHistoriesController < ApiController
  def index
    @trades = Trade
      .search_with(params[:filter], params[:sorting], params[:page], params[:count])
      .where(summary: false)
      .accessible_orders(current_user.id)
      .order(id: :desc)
  end

end
