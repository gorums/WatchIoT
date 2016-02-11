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
    @emails = Email.my_emails(@user.id)

    @teams = Team.my_team @user.id
    @teams_belong = Team.i_belong @user.id

    @in = valid_tab? ? params[:val] : ''
  end

  ##
  # Patch /:username/setting/profile
  #
  def profile
    redirect_to '/' + @user.username + '/setting'

    flash_log_profile if @user.update(profile_params)
  rescue => ex
    flash[:error] = 'Profile update failed'
  end

  ##
  # Post /:username/setting/account/add/email
  #
  def account_add_email
    redirect_to '/' + login_user.username + '/setting/account'

    email_s = email_params[:email]
    Email.add_email(@user.id, email_s)
    flash_log_add_email email_s
  rescue => ex
    flash[:error] = ex.message
  end

  ##
  # Delete /:username/setting/account/remove/email/:id
  #
  def account_remove_email
    redirect_to '/' + @user.username + '/setting/account'

    email_s = Email.remove_email(@user.id, params[:id])
    flash_log_remove_email email_s
  rescue => ex
    flash[:error] = ex.message
  end

  ##
  # Get /:username/setting/account/verify/email/:id
  #
  def account_verify_email
    redirect_to '/' + @user.username + '/setting/account'

    email_s = Email.send_verify(@user.id, params[:id])
    flash_log_verify_email email_s
  rescue => ex
    flash[:error] = ex.message
  end

  ##
  # Get /:username/setting/account/principal/email/:id
  #
  def account_principal_email
    email = Email.where(id: email_id_param[:id]).where(user_id: @user.id).take || not_found
    save_log 'Set email ' + email +'like principal',
             'Setting', @user.id if Email.principal(email)

    redirect_to '/' + @user.username + '/setting/account'
  end

  ##
  # Patch /:username/setting/account/chpassword
  #
  def account_ch_password
    save_log 'Change password', 'Setting',
             @user.id if User.change_passwd(@user, passwd_params)

    redirect_to '/' + @user.username + '/setting/account'
  end


  ##
  # Patch /:username/setting/account/chusername
  #
  def account_ch_username
    old_username = @user.username
    save_log 'Change username <b>' + old_username + '</b> by ' + params[:username],
             'Setting', @user.id if @user.update(username_params)

    redirect_to '/' + @user.username + '/setting/account'
  end

  ##
  # Delete /:username/setting/account/delete
  #
  def account_delete
    return if @user.username != username_params[:username]
    # you have to transfer or your spaces or delete their
    return if Space.where(user_id: @user.id).any?

    # disable user
    User.disable @user

    cookies.clear
    redirect_to root_url
  end

  ##
  # Post /:username/setting/team/add
  #
  def team_add
    user_member = User.find_member(@user.id, email_params[:email])
    return if user_member.nil?

    # if exist throw exception
    return if Team.where(user_id: @user.id).where(user_team_id: user_member.id).exists?

    team = Team.new(user_id: @user.id, user_team_id: user_member.id)
    if team.save
      Notifier.send_new_team_email(@user, user_member, email_params[:email]).deliver_later
      save_log 'Adding a new member <b>' + email_params[:email] + '</b>',
               'Setting', @user.id
    end

    redirect_to '/' + @ser.username + '/setting/team'
  end

  ##
  # Delete /:username/setting/team/delete
  #
  def team_delete
    team = Team.where(user_id: @user.id)
               .where(user_team_id: params[:id]).take || not_found

    save_log 'Delete a member <b>' + user_email(params[:id]) + '</b>',
               'Setting', @user.id if team.destroy

    redirect_to '/' + @user.username + '/setting/team'
  end

  ##
  # Patch /:username/setting/key/generate
  #
  def key_generate
    begin
      api_key_uuid = SecureRandom.uuid
    end while ApiKey.exists?(:api_key => api_key_uuid)

    api_key = ApiKey.find_by_id @user.api_key_id
    api_key.api_key = api_key_uuid

    save_log 'Change api key',
             'Setting', @user.id if api_key.save

    redirect_to '/' + @user.username + '/setting/api'
  end

  private

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

  ##
  # Member team params
  #
  def member_params
    params.require(:email).permit(:email)
  end

  ##
  # Filter method
  # if the request was doing for the user login
  #
  def allow_me
    @user = User.find_by_username(params[:username]) || not_found
    @user if auth? && login_user.username == @user.username || unauthorized
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
  # Set profile flash and log
  #
  def flash_log_profile
    save_log 'Edit the profile setting',
             'Setting', @user.id
    flash[:notice] = 'Profile updated correctly'
  end

  ##
  # Set add email flash and log
  #
  def flash_log_add_email(email)
    save_log 'Add new email <b>' + email + '</b>',
               'Setting', @user.id
    flash[:notice] = 'Added a new email correctly'
  end

  ##
  # Set remove email flash and log
  #
  def flash_log_remove_email(email)
    save_log 'Delete email <b>' + email + '</b>',
             'Setting', @user.id
    flash[:notice] = 'The email was remove correctly'
  end

  ##
  # Set verify email flash and log
  #
  def flash_log_verify_email(email)
    save_log 'Send to verify the email <b>' + email + '</b>',
             'Setting', @user.id
    flash[:notice] = 'The email to verify was sending correctly'
  end
end
