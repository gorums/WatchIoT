##
# User controller
#
class UsersController < ApplicationController

  after_filter :find_reset_user_by_token, :only => [:reset, :do_reset]
  after_filter :find_active_user_by_token, :only => :active
  after_filter :find_verify_email_by_token, :only => :verify_email
  after_filter :find_active_user_by_token, :only => [:invite, :do_invite]
  ##
  # GET /register
  #
  def register
    @user = User.new
    @email = Email.new
  end

  ##
  # GET /forgot
  #
  def forgot
    @user = me || User.new
  end

  ##
  # Post /forgot_notif
  #
  def forgot_notification
    User.send_forgot_notification user_forget_params[:username]
  end

  ##
  # Get /reset
  #
  def reset
    @token = params[:token]
  end

  ##
  # Patch /do_reset
  #
  def do_reset
    redirect_to '/login'

    User.change_passwd(@user, params[:user], false)
    @verifyClient.destroy!
  rescue => ex
  end

  ##
  # Get /active
  #
  def active
    redirect_to '/' + user.username

    User.active_account(@user, @email, @verifyClient)
    Notifier.send_signup_verify_email(@user, @email.email).deliver_later

    cookies[:auth_token] = @user.auth_token
  rescue => ex
  end

  ##
  # Get /verify_email
  #
  def verify_email
    @email.update(checked: true)
    verifyClient.destroy!
  rescue => ex
  end

  ##
  # Get /invited
  #
  def invite
    @token = params[:token]
  end

  ##
  # Patch /do_invited
  #
  def do_invite
    redirect_to '/' + @user.username
    email = Email.email_to_activate(@verifyClient.user_id, @verifyClient.data) || not_found

    @user.username = user_params[:username]
    @user.passwd = user_params[:passwd]
    @user.passwd_confirmation = user_params[:passwd_confirmation]

    Notifier.send_signup_verify_email(@user, email.email).deliver_later if
        User.save_user_and_mail(@user, email, true)

    cookies[:auth_token] = @user.auth_token
  rescue => ex
  end

  ##
  # POST /do_register
  #
  def do_register
    @user = User.new(user_params)
    @email = email_params[:email]

    User.transaction do
      begin
        #TODO: verificate passwd confirmation
        User.save_user_and_mail @user, Email.new(email: @email)
        token = VerifyClient.create_token(@user.id, @email, 'register')
        Notifier.send_signup_email(@user, @email, token).deliver_later
      rescue
        raise ActiveRecord::Rollback, 'Can register the account!'
      end
    end

    render 'need_verify_notif'
  end

  ##
  # Get /login
  #
  def login
    @user = User.new
  end

  ##
  # Get /do_login_omniauth
  # Login with omniauth
  #
  def do_omniauth
    auth = request.env['omniauth.auth']
    user = User.find_by_provider_and_uid(auth['provider'], auth['uid']) || User.create_with_omniauth(auth)

    cookies[:auth_token] = user.auth_token
    redirect_to '/' + user.username
  end

  ##
  # POST /do_login
  #
  def do_login
    user = User.authenticate(params[:email], params[:passwd])
    return user_cannot_login if user.nil?

    cookies.permanent[:auth_token] = user.auth_token if params[:remember_me]
    cookies[:auth_token] = user.auth_token unless params[:remember_me]
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
  # User foget params
  #
  def user_forget_params
    params.require(:user).permit(:username)
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
  # Get a token
  #
  def find_reset_user_by_token
    @verifyClient = VerifyClient.find_token params[:token], 'reset' || not_found
    @user = User.where(id: @verifyClient.user_id).take || not_found
  end

  ##
  # Get a token
  #
  def find_active_user_by_token
    @verifyClient = VerifyClient.find_token params[:token], 'register' || not_found

    @email = Email.email_to_activate(@verifyClient.user_id, @verifyClient.data) || not_found
    @user = User.where(id: @verifyClient.user_id).take || not_found
  end

  ##
  # Get a token
  #
  def find_verify_email_by_token
    @verifyClient = VerifyClient.find_token params[:token], 'verify_email' || not_found

    @email = Email.email_to_check(@verifyClient.user_id, @verifyClient.data) || not_found
    @user = User.where(id: @verifyClient.user_id).take || not_found
  end

  ##
  # Get a token
  #
  def find_invite_user_by_token
    @verifyClient = VerifyClient.find_token params[:token], 'invited' || not_found
    @user = User.where(id: @verifyClient.user_id).take || not_found
  end

end
