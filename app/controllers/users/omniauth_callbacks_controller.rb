class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def eve_online
    @user = User.find_for_eve_online_oauth(request.env['omniauth.auth'])
    #id,name setting
    session[:user_id] = @user.uid
    session[:user_name] = @user.name
    #GET access token
    auth = request.env["omniauth.auth"]
    token = auth["credentials"]["token"]
    session[:access_token] = token
    session[:expires_at] = auth["credentials"]["expires_at"]
    session[:refresh_token] = auth["credentials"]["refresh_token"]
    session[:character] = User.get_character_account_read(get_token, @user.uid)
    # corp 初回
    if Corp.find_by_corporation_id(session[:character].corporation_id).nil? && session[:character].corporation_id.present?
      corp = Corp.new
      corp.corporation_id = session[:character].corporation_id
      corp.corporation_name = session[:character].corporation_name
      corp.save!
    end
    if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication
        set_flash_message(:notice, :success, :kind => "Eve Online") if is_navigational_format?
    end
  end
end
