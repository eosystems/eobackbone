class Api::LocationsController < ApiController
  def index
    if params[:keyword].present?
      @locations = StaStation
        .search({ station_name_cont_all: params[:keyword].split(" ") })
        .result
        .limit(10)
      render json: { results: @locations }
    else
      render json: { results: [] }
    end
  end
end
