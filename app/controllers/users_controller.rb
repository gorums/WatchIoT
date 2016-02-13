##
# User controller
#
class UsersController < ApplicationController
  ##
  # GET /register
  #
  def register
    @user = User.new
    @email = Email.new
  end

  ##
  # POST /do_register
  #
  def do_register
    User.register user_params, email_params[:email]

    render 'need_verify_notification'
  rescue => ex
    render 'register'
    flash[:error] = ex.message
  end

  ##
  # Get /login
  #
  def login
    @user = User.new
  end

  ##
  # POST /do_login
  #
  def do_login
    User.login(user_params[:email], user_params[:passwd], user_params[:remember_me])

    redirect_to '/' + user.username
  rescue => ex
    render 'login'
    flash[:error] = ex.message
  end

  ##
  # Get /do_omniauth
  #
  def do_omniauth
    User.omniauth

    redirect_to '/' + user.username
  rescue => ex
    flash[:error] = ex.message
  end

  ##
  # Get /logout
  #
  def logout
    cookies.clear
    redirect_to root_url
  end

  private

  ##
  # User params
  #
  def user_params
    params.require(:user).permit(:passwd, :passwd_confirmation, :username)
  end

  ##
  # Email params
  #
  def email_params
    params.require(:email).permit(:email)
  end
end
