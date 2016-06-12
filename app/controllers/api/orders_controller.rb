class Api::OrdersController < ApiController
  def index
    corp = Order.arel_table[:corporation_id]
    order_by = Order.arel_table[:order_by]
    @orders = Order
      .search_with(params[:filter], params[:sorting], params[:page], params[:count])
      .where(corp.eq(session[:character]["corporation_id"]).or(order_by.eq(session[:user_id])))
      .order(id: :desc)
  end

  def show
    @order = Order
      .preload(:order_details)
      .find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    # TODO: POSTされたステータスをそのままいれてはいけない
    @order.processing_status = params[:status]
    if @order.save
      render json: { }
    else
      render json: { error: "something wrong" }
    end
  end
end
