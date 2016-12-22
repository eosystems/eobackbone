class Api::ApiManagementsController < ApiController
  def index
    @manegements = nil
    # リクルーター以上のAPI権限を持っている場合は会社の全てを参照できる
    # そうでない場合は自分の権限を参照できる
    if current_user.has_api_manager_role? || current_user.has_recruit_role?
      @managements = ApiManagement
        .search_with(params[:filter], params[:sorting], params[:page], params[:count])
        .accessible_corp_api_management(
          current_user.id,
          current_user.uid,
          current_character.corporation_id)
        .order(id: :desc)
    else
      @managements = ApiManagement
        .search_with(params[:filter], params[:sorting], params[:page], params[:count])
        .accessible_self_api_management(current_user.id, current_user.uid)
        .order(id: :desc)
    end

    # 管理権限を持っていない場合はMaskをかける
    if !current_user.has_api_manager_role?
      api_mask(@managements)
    end
  end

  def show
    @management = ApiManagement.find(params[:id])
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
    if @management.uid == current_user.id ||
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

  def api_mask(targets)
    @managements.each do |m|
      m.api_mask
    end
  end

end
