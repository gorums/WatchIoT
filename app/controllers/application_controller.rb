##
# Application controller
#
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :me
  helper_method :auth?
  helper_method :login_user_email
  helper_method :login_api_key
  helper_method :param_user

  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from ActionController::BadRequest, with: :render_400

  private

  ##
  # This method return the client api key
  #
  def login_api_key
    api_key = ApiKey.find_by(id: me.api_key_id) unless me.nil?
    api_key.api_key || ''
  end

  ##
  # This method return the user authenticate or nil
  #
  def me
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
    Email.find_principal_by_user me.id || ''
  end

  ##
  # If exist user authenticate
  #
  def auth?
    me != nil
  end

  ##
  # Throw RoutingError exception
  #
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  ##
  # Throw RoutingError exception
  #
  def bad_request
    raise ActionController::BadRequest.new('Bad request')
  end

  ##
  # Throw RoutingError exception
  #
  def unauthorized
    raise Errors::UnauthorizedError.new('Unauthorized')
  end

  ##
  # Render not found page
  #
  def render_404
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end

  ##
  # Render unauthorized page
  #
  def render_401
    render file: "#{Rails.root}/public/401.html", layout: false, status: 401
  end

  ##
  # Render bad request page
  #
  def render_400
    render file: "#{Rails.root}/public/400.html", layout: false, status: 400
  end

  ##
  # Save logs by actions
  #
  def save_log(description, action, owner_user_id)
    Log.save_log(description,  action, owner_user_id, me.id)
  end

  ##
  # if the request was doing for the user login or an user team
  #
  def allow
    @user = User.find_by_username(params[:username]) || not_found
    @user if auth? && @user.username == me.username || Team.member?(@user.id, me.id) || unauthorized
  rescue Errors::UnauthorizedError
    render_401
  end

  ##
  # Get space to transfer
  #
  def allow_space
    @space = Space.find_by_user_and_name @user.id, params[:namespace] || not_found
  end
end
