class Api::MarketPricesController < ApiController
  def show
    @item = InvType.where(type_id: params[:id]).first
    @sell_min_price = MarketOrder.jita_sell_price(params[:id])
    @buy_max_price = MarketOrder.jita_buy_price(params[:id])

    render json: { item: @item, buy_max_price: @buy_max_price, sell_min_price: @sell_min_price }
  end
end
