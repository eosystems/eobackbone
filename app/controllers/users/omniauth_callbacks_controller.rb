class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # TODO: 要リファクタ
  def eve_online
    @user = User.find_for_eve_online_oauth(request.env['omniauth.auth'])
    auth = request.env["omniauth.auth"]
    token = auth["credentials"]["token"]

    #id,name setting
    session[:user_id] = @user.id
    session[:user_name] = @user.name
    #GET access token
    session[:access_token] = token
    session[:expires_at] = auth["credentials"]["expires_at"]
    session[:refresh_token] = auth["credentials"]["refresh_token"]
    session[:character] = Character.initialized_by(get_token, @user.uid)

    # Tokenの更新
    @user.token = token
    @user.refresh_token = auth["credentials"]["refresh_token"]
    @user.expire = Time.at(auth["credentials"]["expires_at"])
    @user.save

    # corp 初回
    if Corporation.find_by_corporation_id(session[:character].corporation_id).nil? && session[:character].corporation_id.present?
      corp = Corporation.new
      corp.corporation_id = session[:character].corporation_id
      corp.corporation_name = session[:character].corporation_name
      corp.save!
    end

    # user情報更新
    user_detail = UserDetail.find_or_initialize_by(user_id: User.find_by_uid(@user.uid))
    user_detail.attributes = {
      user_id: @user.id,
      corporation_id: session[:character].corporation_id,
      alliance_id: session[:character].alliance_id,
    }
    user_detail.save!

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Eve Online") if is_navigational_format?
    end
  end
end
