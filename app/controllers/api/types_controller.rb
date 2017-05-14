class Api::TypesController < ApiController
  def index
    if params[:keyword].present?
      @inv_types = InvType
        .market_items
        .search({ type_name_cont_all: params[:keyword].split(" ") })
        .result
        .limit(10)
      render json: { results: @inv_types }
    else
      render json: { results: [] }
    end
  end
end
