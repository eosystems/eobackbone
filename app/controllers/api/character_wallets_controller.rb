class Api::CharacterWalletsController < ApiController
  def show
    @character_wallets = nil

    user = User.find_by(uid: params[:id])
    if user.nil?
      render json: { error: 'User Not Found' }, status: 404
    end

    # Api管理者の場合は情報閲覧可能、リクルーターの場合はほぼ全てをフィルターする
    if current_user.has_api_manager_role? || current_user.has_recruit_role? || current_user.uid == params[:id].to_s
      page_num = params[:page] || 1
      result = EsiClient.new(User.user_token(user)).fetch_character_wallet_journal(user.uid, page_num)
      if result.error.present?
        render json: { error: result.error }, status: result.status
      end

      @items = result.item
      @has_next_page = result.has_next_page
      # フィルター処理
      unless current_user.has_api_manager_role? || current_user.uid == params[:id].to_s
        api_mask(@items)
      end
    else
      render json: { error: "You have not corrent auth"}, status: 403
    end
  end

  private

  def api_mask(items)
    items.each do |item|
      item.amount = 'xxxxxxxx'
      item.balance = 'xxxxxxxx'
      item.context_id = 'xxxxxxxxx'
      item.context_id_type = 'xxxxxxxxx'
      item.description = 'xxxxxxxx'
      item.first_party_id = 'xxxxxxxx'
      item.ref_type = 'xxxxxxxxxx'
      item.secound_party_id = 'xxxxxxxxx'
    end
  end
end
