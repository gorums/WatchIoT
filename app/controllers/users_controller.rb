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
  # GET /forgot
  #
  def forgot
    @user = me || User.new
  end

  ##
  # Post /forgot_notf
  #
  def forgot_notif
    username = user_forget_params[:username]
    user = User.find_by_username(username) || not_found
    email = user_email(user.id)
    # TODO: throw exception
    return if email.nil?
    token = VerifyClient.create_token(user.id, email, 'reset')
    Notifier.send_forget_passwd_email(user, token, email).deliver_later
  end

  ##
  # Get /reset
  #
  def reset
    verifyClient = find_token(type = 'reset')
    @user = User.where(id: verifyClient.user_id).take || not_found
    @token = params[:token]
  end

  ##
  # Patch /do_reset
  #
  def do_reset
    verifyClient = find_token(type = 'reset')
    user = User.where(id: verifyClient.user_id).take || not_found

    verifyClient.destroy! if User.change_passwd(user, params[:user], false)

    redirect_to '/login'
  end

  ##
  # Get /active
  #
  def active
    verifyClient = find_token(type = 'register')

    email = Email.email_to_activate(verifyClient.user_id, verifyClient.data) || not_found
    user = User.where(id: verifyClient.user_id).take || not_found

    User.active_account(user, email, verifyClient)
    Notifier.send_signup_verify_email(user, email.email).deliver_later

    cookies[:auth_token] = user.auth_token
    redirect_to '/' + user.username
  end

  ##
  # Get /verify_email
  #
  def verify_email
    verifyClient = find_token(type = 'verify_email')

    @email = Email.email_to_check(verifyClient.user_id, verifyClient.data) || not_found
    @user = User.where(id: verifyClient.user_id).take || not_found

    verifyClient.destroy if @email.update(checked: true)
  end

  ##
  # Get /invited
  #
  def invited
    verifyClient = find_token(type = 'invited')
    @user = User.where(id: verifyClient.user_id).take || not_found
    @token = params[:token]
  end

  ##
  # Patch /do_invited
  #
  def do_invited
    verifyClient = find_token(type = 'invited')

    email = Email.email_to_activate(verifyClient.user_id, verifyClient.data) || not_found
    user = User.where(id: verifyClient.user_id).take || not_found

    user.username = user_params[:username]
    user.passwd = user_params[:passwd]
    user.passwd_confirmation = user_params[:passwd_confirmation]

    Notifier.send_signup_verify_email(user, email.email).deliver_later if
        User.save_user_and_mail(user, email, true)

    cookies[:auth_token] = user.auth_token
    redirect_to '/' + user.username
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
  def find_token(type)
    VerifyClient.where(token: params[:token])
        .where(concept: type).take || not_found
  end
end
