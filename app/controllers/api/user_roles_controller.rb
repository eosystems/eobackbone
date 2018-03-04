class Api::UserRolesController < ApiController
  def index
    @roles = nil
    if current_user.has_manager_role?
      @roles = UserRole
        .search_with(params[:filter], params[:sorting], params[:page], params[:count])
        .accessible_corp_api_management(
          current_user.id,
          current_user.uid,
          current_character.corporation_id)
        .order(id: :desc)
    end
  end

  def create
    @management = ApiManagement.new(api_management_params)
    @management.uid = current_user.id
    if @management.save
      render json: { message: "success"}
    else
      render json: { error: "Something Wrong"}, status: 500
    end
  end

  def destroy
    @management = ApiManagement.find(params[:id])
    if @management.uid == current_user.id.to_s ||
        @management.character_id == current_user.uid ||
        current_user.has_api_manager_role?
      @management.destroy
      render json: {}
    else
      render json: { error: "You have not corrent auth"}, status: 500
    end
  end

  private

  def api_management_params
    params
      .require(:management)
      .permit(:id, :key_id, :v_code, :uid, :character_id, :character_name,
             :corporation_id, :alliance_id, :access_mask, :alpha, :full_api,
             :expires, :api_manage_corporation_id)
  end

end
