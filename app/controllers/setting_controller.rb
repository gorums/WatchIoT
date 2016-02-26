##
# Setting controller
#
class SettingController < ApplicationController
  layout 'dashboard'

  before_filter :allow_me

  ##
  # Get /:username/setting
  #
  def show
    @email = Email.new
    @emails = Email.find_by_user(@user.id)
    @teams = Team.my_teams @user.id
    @teams_belong = Team.belong_to @user.id
    @in = valid_tab? ? params[:val] : ''
  end

  ##
  # Patch /:username/setting/profile
  #
  def profile
    redirect_to '/' + @user.username + '/setting'

    @user.update(profile_params)

    flash_log('Edit the profile setting', 'Profile updated correctly')
  rescue => ex
    flash[:error] = 'Profile update failed'
  end

  ##
  # Post /:username/setting/account/add/email
  #
  def account_add_email
    redirect_to '/' + me.username + '/setting/account'

    Email.add_email(@user.id, email_params[:email])

    flash_log('Add new email <b>' + email_params[:email] + '</b>',
                        'Added a new email correctly')
  rescue => ex
    flash[:error] = ex.message
  end

  ##
  # Delete /:username/setting/account/remove/email/:id
  #
  def account_remove_email
    redirect_to '/' + @user.username + '/setting/account'

    email_s = Email.remove_email(@user.id, params[:id])

    flash_log('Delete email <b>' + email_s + '</b>',
              'The email was remove correctly')
  rescue => ex
    flash[:error] = ex.message
  end

  ##
  # Get /:username/setting/account/verify/email/:id
  #
  def account_verify_email
    redirect_to '/' + @user.username + '/setting/account'

    email_s = Email.send_verify(@user.id, params[:id])

    flash_log('Send to verify the email <b>' + email_s + '</b>',
              'The email to verify was sending correctly')
  rescue => ex
    flash[:error] = ex.message
  end

  ##
  # Get /:username/setting/account/principal/email/:id
  #
  def account_principal_email
    redirect_to '/' + @user.username + '/setting/account'

    email = Email.principal(@user.id, params[:id])

    flash_log('Set email <b>' + email.email + '</b> like principal',
                  'The email was set principal correctly')
  rescue => ex
    flash[:error] = ex.message
  end

  ##
  # Patch /:username/setting/account/password
  #
  def account_ch_password
    redirect_to '/' + @user.username + '/setting/account'

    User.change_passwd(@user, passwd_params)

    flash_log('Change password', 'The password was change correctly')
  rescue => ex
    flash[:error] = ex.message
  end

  ##
  # Patch /:username/setting/account/username
  #
  def account_ch_username
    redirect_to '/' + @user.username + '/setting/account'

    old_username = @user.username
    User.change_username @user, params[:username]

    flash_log('Change username <b>' + old_username + '</b> by ' + params[:username],
              'The new username was save correctly')
  rescue => ex
    flash[:error] = ex.message
  end

  ##
  # Delete /:username/setting/account/delete
  #
  def account_delete
    redirect_to root_url

    User.account_delete @user, username_params[:username]

    cookies.clear
  rescue => ex
    flash[:error] = ex.message
  end

  ##
  # Post /:username/setting/team/add
  #
  def team_add
    redirect_to '/' + @ser.username + '/setting/team'

    Team.add_member @user, email_params[:email]

    flash_log('Adding a new member <b>' + email_params[:email] + '</b>',
              'The member was add correctly')
  rescue => ex
    flash[:error] = ex.message
  end

  ##
  # Delete /:username/setting/team/delete
  #
  def team_delete
    redirect_to '/' + @user.username + '/setting/team'

    Team.remove_member @user, params[:id]

    flash_log('Delete a member <b>' + user_email(params[:id]) + '</b>',
              'The member was delete correctly')
  rescue => ex
    flash[:error] = ex.message
  end

  ##
  # Patch /:username/setting/key/generate
  #
  def key_generate
    redirect_to '/' + @user.username + '/setting/api'

    ApiKey.generate @user

    flash_log('Change api key', 'The api key was change correctly')
  rescue => ex
    flash[:error] = ex.message
  end

  private

  ##
  # Filter method
  # if the request was doing for the user login
  #
  def allow_me
    @user = User.find_by_username(params[:username]) || not_found
    @user if auth? && me.username == @user.username || unauthorized
  rescue Errors::UnauthorizedError
    render_401
  end

  ##
  # Validate tabs when redirect is throw
  #
  def valid_tab?
    %w(account team api).any? { |word|  params[:val] == word }
  end

  ##
  # Set flash and log
  #
  def flash_log(log_description, msg)
    save_log log_description, 'Setting', @user.id
    flash[:notice] = msg
  end

  ##
  # Profile params
  #
  def profile_params
    params.require(:user).permit(:first_name, :last_name, :country_code,
                                 :address, :phone, :receive_notif_last_new)
  end

  ##
  # Email params
  #
  def email_params
    params.require(:email).permit(:email)
  end

  ##
  # Email id params
  #
  def email_id_param
    params.require(:email).permit(:id)
  end

  ##
  # Passwd change params
  #
  def passwd_params
    params.require(:user).permit(:passwd, :passwd_new, :passwd_confirmation)
  end

  ##
  # Passwd change params
  #
  def username_params
    params.require(:user).permit(:username)
  end
end
