class Api::ApiManagementsController < ApiController
  def index
    @manegements = nil
    @managements = ApiManagement
      .accessible_api_management(current_character.corporation_id)
      .order(id: :desc)
  end

  def show
    @management = ApiManagement.find(params[:id])
  end

  def create
    @management = ApiManagement.new(api_management_params)
    @management.uid = current_user.id
    @management.api_manage_corporation_id = 1
    if @management.save
      render json: { message: "success"}
    else
      render json: { error: "Something Wrong"}, status: 500
    end
  end

  def update
    @management = ApiManagement.find(params[:id])
    if @management.save
      render json: {}
    else
      render json: { error: "something wrong" }
    end
  end

  def destroy
    @management = ApiManagement.find(params[:id])
    @management.destroy
    render json: {}
  end

  private

  def api_management_params
    params
      .require(:management)
      .permit(:id, :key_id, :v_code, :uid, :character_id,
             :corporation_id, :alliance_id, :access_mask, :alpha, :full_api,
             :expires, :api_manage_corporation_id)
  end
end
