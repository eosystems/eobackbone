class Api::DashboardsController < ApiController
  def index
    @boards = Dashboard.accessible_corp(current_user.id)
    render json: {results: @boards}
  end

  def show
    @board = Dashboard.find(params[:id])
    render json: {results: @board}
  end
end
