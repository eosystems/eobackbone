class Api::CorpMemberController < ApiController
  def index
    @manegements = nil
    # リクルーター以上のAPI権限を持っている場合は会社の全てを参照できる
    # そうでない場合も今はメンバー全員の情報を見ることができる
    if current_user.has_api_manager_role? || current_user.has_recruit_role?
      @managements = CorpMember
        .search_with(params[:filter], params[:sorting], params[:page], params[:count])
        .accessible_corp_member_management(
          current_character.corporation_id)
        .order(id: :desc)
    else
      @managements = ApiManagement
        .search_with(params[:filter], params[:sorting], params[:page], params[:count])
        .accessible_corp_member_management(
          current_character.corporation_id)
        .order(id: :desc)
    end
  end

  def destroy
    @management = Corp.find(params[:id])
    if @management.uid == current_user.id.to_s ||
        @management.character_id == current_user.uid ||
        current_user.has_api_manager_role?
      @management.destroy
      render json: {}
    else
      render json: { error: "You have not corrent auth"}, status: 500
    end
  end

end
