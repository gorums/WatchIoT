##
# Application controller
#
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :login_user
  helper_method :login_user_email
  helper_method :login_api_key
  helper_method :param_user
  helper_method :user_email
  helper_method :user_name

  rescue_from ActionController::RoutingError, with: :render_404

  private

  ##
  # This method return the client api key
  #
  def login_api_key
    api_key = ApiKey.find_by(id: login_user.api_key_id) unless login_user == nil
    api_key.api_key
  end

  ##
  # This method return the user authenticate or nil
  #
  def login_user
    cookie = cookies[:auth_token]
    @current_user ||= User.find_by_auth_token( cookie) if cookie
  end

  def param_user
    params[:username]
  end
  ##
  # This method return the client principal email
  #
  def login_user_email
    email = User.email(login_user.id) unless login_user.nil?
    email.email
  end

  ##
  # This method return the principal email
  #
  def user_email(user_id)
    email = User.email(user_id) unless user_id.nil?
    email.email unless email.nil?
  end

  ##
  # This method return the principal email
  #
  def user_name(user_id)
    user = User.find(user_id) unless user_id.nil?
    user.username
  end

  ##
  # If exist user authenticate
  #
  def auth?
    login_user != nil
  end

  ##
  # Throw RoutingError exception
  #
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  ##
  # Render 404 page
  #
  def render_404
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end

  ##
  # Save logs by actions
  #
  def save_log(description, action, owner_user_id)
    Log.save_log description: description, action: action,
                  user_id: owner_user_id, user_action_id: login_user.ids
  end

  ##
  # if the request was doing for the user login or an user team
  #
  def find_owner
    user = User.find_by_username(params[:username]) || not_found
    return user if auth? && login_user.username == user.username
    return user if Team.where(user_id: user.id).where(user_team_id: login_user.id).any?

    not_found
  end
end
