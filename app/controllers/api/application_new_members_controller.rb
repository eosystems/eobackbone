class Api::ApplicationNewMembersController < ApiController
  def show
    @new_member = ApplicationNewMember.preload(:application).find(params[:id])
  end

  def create
    if params["corporation_id"].blank?
      render json: { error: "コープを選択してください" }, status: 500
      return
    end

    @application = Application.new(corporation_id: params["corporation_id"])
    @application.targetable = ApplicationNewMember.new

    if @application.save
      render json: { message: 'success'}
    else
      render json: { error: "something wrong" }, status: 500
    end
  end
end
