class Api::UserMarketOrdersController < ApiController
  def index
    @orders = UserMarketOrder
      .search_with(params[:filter], params[:sorting], params[:page], params[:count])
      .accessible_orders(current_user.id)
      .order(id: :desc)
  end

end
