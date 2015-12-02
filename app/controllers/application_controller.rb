class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user
  helper_method :current_user_email

  private

  ##
  #This method return the user authenticate or nil
  #
  def current_user
    cookie = cookies[:auth_token]
    @current_user ||= User.find_by_auth_token( cookie) if cookie
  end

  ##
  #This method return the client principal email
  #
  def current_user_email
    email = User.email(current_user.id) if current_user != nil
    email
  end

  ##
  #If exist user authenticate
  #
  def is_auth?
    current_user != nil
  end

end
