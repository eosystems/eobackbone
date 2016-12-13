class Api::CorporationsController < ApiController
  def index
    if params[:keyword].present?
      @corporations = Corporation
        .search({ corporation_name_cont_all: params[:keyword].split(" ") })
        .result
        .limit(5)
      render json: { results: @corporations }
    else
      render json: { results: [] }
    end
  end
end
