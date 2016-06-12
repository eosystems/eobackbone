class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  layout :layout_by_resource

  protected

  def layout_by_resource
    if devise_controller?
      "session"
    else
      "application"
    end
  end

  def get_token
    #create access token
    client = OAuth2::Client.new(Settings.applications.app_id, Settings.applications.app_secret)
    if token_expired?
      refresh_token
    end
    token = session[:access_token]
    OAuth2::AccessToken.new(client, token)
  end

  def get_current_user_id
    session[:user_id]
  end

  def refresh_token
    response = RestClient.post "https://login.eveonline.com/oauth/token",
                               :grant_type => 'refresh_token',
                               :refresh_token => session[:refresh_token],
                               :client_id => Settings.application.app_id,
                               :client_secret => Settings.application_app_secret

    refresh_hash = JSON.parse(response)
    session[:access_token] = refresh_hash['access_token']
    session[:expires_at] = DateTime.current.to_i + refresh_hash['expires_in'].to_i
    session[:refresh_token] = refresh_hash['refresh_token']
  end

  def token_expired?
    expires_at = session[:expires_at]
    current_time = Time.current.to_i
    if expires_at < current_time
      return true
    end
    false
  end

end
