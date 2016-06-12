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
    @order.attributes = permitted_attributes
    @order.order_by = current_user.id

    if @order.save
      render json: { message: "success" }
    else
      render json: { error: "Cannot parse" }, status: 500
    end
  end

  private

  def permitted_attributes
    params
      .require(:order)
      .permit(:sell_price, :is_credit, :station_id, :note)
  end
end
