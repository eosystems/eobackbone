class Api::ApplicationsController < ApiController
  def index
    # リクルーター以上のAPI権限を持っている場合は会社の全てを参照できる
    # そうでない場合も今はメンバー全員の情報は見られない
    if current_user.has_api_manager_role? || current_user.has_recruit_role?
      @applications = Application
        .search_with(params[:filter], params[:sorting], params[:page], params[:count])
        .accessible_corp_member_management(
          current_character.corporation_id, current_user.id)
        .order(id: :desc)
    else
      @applications = Application
        .search_with(params[:filter], params[:sorting], params[:page], params[:count])
        .accessible_corp_member_management(
          current_character.corporation_id, current_user.id)
        .where(user_id: current_user.id)
        .order(id: :desc)
    end
  end

  def update
    @application = Application.find(params[:id])
    unless @application.targetable.has_update_operation_role(current_user)
      render json: { error: "この操作を行う権限がありません" }, status: 403
    end

    @application.process_user = current_user
    @application.processing_status = params[:status] if params[:status].present?
    @application.validate!

    if @application.processing_status == ProcessingStatus::DONE.id
      @application.exec_done_process
      @application.done_date = Time.zone.now
    end

    if @application.save
      render json: {}
    else
      render json: { error: "something wrong" }
    end
  end

end
