class Api::UserRolesController < ApiController
  def index
    @roles = nil
    if current_user.has_manager_role?
      @roles = UserRole
        .search_with(params[:filter], params[:sorting], params[:page], params[:count])
        .accessible_corp_management(current_character.corporation_id)
        .order(id: :desc)
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
