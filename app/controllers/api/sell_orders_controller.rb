class Api::SellOrdersController < ApiController
  def index
    @order = InventoryParseService.new.parse(params[:form])
    if @order.present?
      @order.retrieval!
    else
      render json: { error: "Cannot parse" }, status: 500
    end
  end

  def create
    @order = InventoryParseService.new.parse(params[:form])
    @order.retrieval!
    @order.order_by = current_user.id

    if @order.save
      render json: { message: "success" }
    else
      render json: { error: "Cannot parse" }, status: 500
    end
  end
end
