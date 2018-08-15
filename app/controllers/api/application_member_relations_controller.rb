class Api::ApplicationMemberRelationsController < ApiController
  def show
    @member_relation = ApplicationMemberRelation.preload(:application).find(params[:id])
  end

  def create
    if params["character_id"].blank?
      render json: { error: "Subキャラクターを選択してください" }, status: 400
      return
    end

    main = CorpMember.find_by(character_id: current_user.uid)
    sub = CorpMember.find_by(character_id: params['character_id'])

    if main.blank?
      render json: { error: "Mainキャラクターが見つかりません。先に新規メンバー登録をしてください" }, status: 404
      return
    end

    if sub.blank?
      render json: { error: "Subキャラクターが見つかりません。先に新規メンバー登録をしてください" }, status: 404
      return
    end

    @application = Application.new(corporation: current_user.user_detail.corporation)
    @application.targetable = ApplicationMemberRelation.new(
      character_id: sub.character_id,
      character_name: sub.character_name,
      main_character_id: main.character_id,
      main_character_name: main.character_name,
    )
    @application.user = current_user

    if @application.save
      render json: { message: 'success'}
    else
      render json: { error: "something wrong" }, status: 500
    end
  end
end
