class Api::BuyOrdersController < ApiController
  def index
    @orders = Order
      .search_with(params[:filter], params[:sorting], params[:page], params[:count])
      .buy_orders
      .accessible_orders(current_character.corporation_id, current_user.id)
      .order(id: :desc)
  end

  def show
    @order = Order.preload(:order_details).find(params[:id])
  end

  def create
    # データ更新中はNG
    if System.all.count > 0
      render json: {error: "データ入れ替え中のため使用できません 5分程度お待ちください"}, status: 500
    end
    @order = Order.new.parse_buy_orders(params[:form])
    @order.attributes = permitted_attributes
    @order.processing_status = ProcessingStatus::IN_PROCESS.id
    @order.order_by = current_user.id
    @order.corporation_id = current_character.corporation_id
    @order.is_buy = true
    if @order.save
      render json: { message: "success" }
    else
      render json: { error: "something wrong" }, status: 500
    end
  end

  def update
    @order = Order.find(params[:id])
    @order.processing_status = params[:status] if params[:status].present?
    if params[:form]
      @order.update_buy_orders(params[:form])
      @order.attributes = permitted_attributes
      @order.processing_status = ProcessingStatus::CREATE_CONTRACT.id
      @order.assigned_user_id = current_user.id
      @order.estimate_date = Time.zone.now
    end
    
    if @order.save
      render json: { }
    else
      render json: { error: "something wrong" }
    end
  end

  def destroy
    @order = Order.accessible_orders(current_character.corporation_id, current_user.id).find(params[:id])
    render json: { error: 'No Record' } if @order.nil?

    if @order.can_change_to_delete?(current_user)
      @order.destroy
      render json: {}
    else
      render json: { error: "Permission Deny" }
    end
  end

  private

  def permitted_attributes
    params
      .require(:order)
      .permit(:total_estimate_buy_price, :total_estimate_sell_price, :department_id, :note, :total_price, :total_jita_sell_price, :sell_price)
  end
end
