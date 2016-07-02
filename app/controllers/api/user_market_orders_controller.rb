class Api::UserMarketOrdersController < ApiController
  def index
    @orders = UserMarketOrder
      .search_with(params[:filter], params[:sorting], params[:page], params[:count])
      .accessible_orders(current_user.id)
      .order(id: :desc)
  end

  def show
    @order = UserMarketOrder.find(params[:id])
  end

  def update
    @order = UserMarketOrder.find(params[:id])
    @order.monitor = params[:monitor]
    if @order.save
      render json: { }
    else
      render json: { error: "something wrong"}
    end
  end
end
