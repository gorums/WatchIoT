##
# Application controller
#
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :current_user_email

  rescue_from ActionController::RoutingError, with: :render_404

  private

  ##
  # This method return the user authenticate or nil
  #
  def current_user
    cookie = cookies[:auth_token]
    @current_user ||= User.find_by_auth_token( cookie) if cookie
  end

  ##
  # This method return the client principal email
  #
  def current_user_email
    email = User.email(current_user.id) unless current_user == nil
    email
  end

  ##
  # This method return the client api key
  #
  def current_api_key
    api_key = User.email(current_user.api_key_id) unless current_user == nil
    api_key
  end

  ##
  # If exist user authenticate
  #
  def auth?
    current_user != nil
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
    log = Log.new description: description, action: action,
                  user_id: owner_user_id, user_action_id: current_user.id
    log.save
  end
end
