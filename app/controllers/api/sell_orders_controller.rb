class Api::SellOrdersController < ApplicationController
  def index
    @order = InventoryParseService.new.parse(params[:form])
    if @order.present?
      @order.retrieval!
    else
      render json: { error: "Cannot parse" }, status: 500
    end
  end

  def create
  end
end
