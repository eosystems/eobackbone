class Api::CorpMembersController < ApiController
  def index
    @corp_members = nil
    # リクルーター以上のAPI権限を持っている場合は会社の全てを参照できる
    # そうでない場合も今はメンバー全員の情報は見られない
    if current_user.has_api_manager_role? || current_user.has_recruit_role?
      @corp_members = CorpMember
        .search_with(params[:filter], params[:sorting], params[:page], params[:count])
        .accessible_corp_member_management(
          current_character.corporation_id)
        .order(id: :desc)
    else
      @corp_members = CorpMember
        .search_with(params[:filter], params[:sorting], params[:page], params[:count])
        .accessible_corp_member_management(
          current_character.corporation_id)
        .where("character_id = ? OR main_character_id = ?", current_character.character_id, current_character.character_id)
        .order(id: :desc)
    end
  end

  def destroy
    @corp_member = CorpMember.find(params[:id])
    if @corp_member.character_id == current_user.uid.to_s ||
        current_user.has_api_manager_role?
      @corp_member.destroy
      render json: {}
    else
      render json: { error: "You have not corrent auth"}, status: 500
    end
  end

end
