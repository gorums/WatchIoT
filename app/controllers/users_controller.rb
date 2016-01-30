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
  # Get /verify
  #
  def verify
    verifyClient = VerifyClient.where(token: params[:id])
                       .where(concept: 'register').take || not_found

    email = Email.email_to_activate(verifyClient.user_id, verifyClient.data) || not_found
    user = User.where(id: verifyClient.user_id).take || not_found

    Notifier.send_signup_verify_email(user, email).deliver_later if
        User.active_account(user, email, verifyClient)

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

    render 'need_verify'
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

end
