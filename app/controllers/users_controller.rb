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
    @user = User.new(user_params)

    User.transaction do
      begin
        User.save_user_and_mail @user, Email.new(email_params)
      rescue
        raise ActiveRecord::Rollback, 'Can register the account!'
      end
    end

    # whether register fine, im going to login in the same time
    cookies[:auth_token] = @user.auth_token
    redirect_to root_url
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
    user = User.authenticate(params[:email], params[:passwd])
    return user_cannot_login if user.nil?

    user_cookies user
    redirect_to '/' + user.username
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

  ##
  # User can login routine
  #
  def user_cannot_login
    flash.now.alert = 'Invalid email or password'
    render :login
  end

  ##
  # Cookies routine
  #
  def user_cookies(user)
    cookies.permanent[:auth_token] = user.auth_token if params[:remember_me]
    cookies[:auth_token] = user.auth_token unless params[:remember_me]
  end

end
