##
# User controller
#
class NotificationsController < ApplicationController

  after_filter :find_reset_user_by_token, :only => [:reset, :do_reset]
  after_filter :find_active_user_by_token, :only => :active
  after_filter :find_verify_email_by_token, :only => :verify_email
  after_filter :find_invite_user_by_token, :only => [:invite, :do_invite]

  ##
  # GET /forgot
  #
  def forgot
    @user = me || User.new
  end

  ##
  # Post /forgot_notification
  #
  def forgot_notification
    VerifyClient.send_forgot_notification user_forget_params[:username]
  rescue => ex
    flash[:error] = ex.message
    render 'forgot'
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
    User.reset_passwd(@user, params[:user], @verifyClient)

    redirect_to '/login'
  rescue => ex
    flash[:error] = ex.message
    render 'reset'
  end

  ##
  # Get /active
  #
  def active
    User.active_account(@user, @email, @verifyClient)

    redirect_to '/' + user.username
  rescue => ex
    flash[:error] = ex.message
  end

  ##
  # Get /verify_email
  #
  def verify_email
    Email.email_verify @email, @verifyClient

  rescue => ex
    flash[:error] = ex.message
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
    User.invite @user, user_params, @verifyClient

    redirect_to '/' + @user.username
  rescue => ex
    flash[:error] = ex.message
    render 'invite'
  end

  private

  ##
  # Get a token
  #
  def find_reset_user_by_token
    find_by_concept 'reset', params[:token]
  end

  ##
  # Get a token
  #
  def find_active_user_by_token
    find_by_concept 'register', params[:token]
    @email = Email.email_to_activate(@verifyClient.user_id, @verifyClient.data) || not_found
  rescue => ex
    not_found
  end

  ##
  # Get a token
  #
  def find_verify_email_by_token
    find_by_concept 'verify_email', params[:token]
    @email = Email.email_to_check(@verifyClient.user_id, @verifyClient.data) || not_found
  rescue => ex
    not_found
  end

  ##
  # Get a token
  #
  def find_invite_user_by_token
    find_by_concept 'invited', params[:token]
  end

  ##
  # Get a token
  #
  def find_by_concept(concept, token)
    @verifyClient = VerifyClient.find_token token, concept || not_found
    @user = User.find(id: @verifyClient.user_id) || not_found
  end

  ##
  # User foget params
  #
  def user_forget_params
    params.require(:user).permit(:username)
  end
end