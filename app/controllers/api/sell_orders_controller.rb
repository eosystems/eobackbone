class Api::SellOrdersController < ApiController
  def index
    # 暫定対応 #45
    s = System.all
    if s.count > 0
      render json: {error: "データ入れ替え中のため使用できません 5分程度お待ちください"}, status: 500
    end
    @order = InventoryParseService.new.parse(params[:form])
    if @order.present?
      begin
        @order.retrieval!
      rescue => e
        render json: {error: e.message}, status: 500
      end
    else
      render json: { error: "Cannot parse" }, status: 500
    end
  end

  def create
    # 暫定対応 #45
    s = System.all
    if s.count > 0
      render json: {error: "データ入れ替え中のため使用できません 5分程度お待ちください"}, status: 500
    end
    @order = InventoryParseService.new.parse(params[:form])
    @order.retrieval!
    @order.attributes = permitted_attributes
    @order.order_by = current_user.id
    @order.corporation_id = current_character.corporation_id

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
      .permit(:sell_price, :is_credit, :station_i, :note, :department_id)
  end
end
