##
# Setting controller
#
class SettingController < ApplicationController
  layout 'dashboard'

  ##
  # Get /:username/setting
  #
  def show
    user = find_owner

    # setting emails data
    @emails = Email.where(user_id: user.id).order(principal: :desc)
    @email = Email.new
    # end setting emails data

    @user = user

    @teams = Team.where(user_id: user.id)
    @teams_belong = Team.where(user_team_id: user.id)
    @in = valid_tab? ? params[:val] : ''
  end

  ##
  # Patch /:username/setting/profile
  #
  def profile
    user = find_owner

    save_log 'Edit the profile setting',
             'Setting', current_user.id if user.update(profile_params)

    redirect_to '/' + user.username + '/setting'
  end

  ##
  # Post /:username/setting/account/email/add
  #
  def account_email_add
    user = find_owner

    email = Email.new(email_params)
    email.user_id = current_user.id
    email.principal = false

    save_log 'Add new email <b>' + email.email + '</b>',
             'Setting', current_user.id if email.save

    redirect_to '/' + current_user.username + '/setting/account'
  end

  ##
  # Delete /:username/setting/account/email/delete/:id
  #
  def account_email_delete
    user = find_owner

    email = Email.where(id: params[:id]).where(user_id: user.id).take
    return email.nil? || email.principal?

    save_log 'Delete email <b>' + email.email + '</b>',
             'Setting', current_user.id if email.destroy

    redirect_to '/' + current_user.username + '/setting/account'
  end

  ##
  # Get /:username/setting/account/email/principal/:id
  #
  def account_email_principal
    user = find_owner

    save_log 'Set email like pincipal',
             'Setting', current_user.id if Email.principal(user.id, params[:id])

    redirect_to '/' + current_user.username + '/setting/account'
  end

  ##
  # Patch /:username/setting/account/chpassword
  #
  def account_ch_password
    user = find_owner

    save_log 'Change password', 'Setting',
             current_user.id if User.change_passwd(user, passwd_params)

    redirect_to '/' + current_user.username + '/setting/account'
  end


  ##
  # Patch /:username/setting/account/chusername
  #
  def account_ch_username
    user = find_owner

    old_username = user.username
    save_log 'Change username <b>' + old_username + '</b> by ' + params[:username],
             'Setting', current_user.id if user.update(username_params)

    redirect_to '/' + user.username + '/setting/account'
  end

  ##
  # Delete /:username/setting/account/delete
  #
  def account_delete
    user = find_owner

    # disable user
    User.disable user

    cookies.clear
    redirect_to root_url
  end

  ##
  # Post /:username/setting/team/add
  #
  def team_add
    user = find_owner
    user_member = User.find_member(params[:email])
    return if user_member.nil?

    # if exist throw exception
    Team.where(user_id: user.id, user_team_id: user_member.id).exists?

    team = Team.new(user_id: user.id, user_team_id: user_member.id)
    if team.save
      Notifier.send_new_team_email(user, params[:email]).deliver_later
      save_log 'Adding a new member <b>' + params[:email] + '</b>',
               'Setting', current_user.id
    end

    redirect_to '/' + user.username + '/setting/team'
  end

  ##
  # Delete /:username/setting/team/delete
  #
  def team_delete
    user = find_owner

    team = Team.where(user_id: user.id)
               .where(user_team_id: params[:id]).take || not_found

    save_log 'Delete a member <b>' + user_email(params[:id]) + '</b>',
               'Setting', current_user.id if team.destroy

    redirect_to '/' + user.username + '/setting/team'
  end

  ##
  # Patch /:username/setting/key/generate
  #
  def key_generate
    user = find_owner

    begin
      api_key_uuid = SecureRandom.uuid
    end while ApiKey.exists?(:api_key => api_key_uuid)

    api_key = ApiKey.find_by_id user.api_key_id
    api_key.api_key = api_key_uuid

    save_log 'Change api key',
             'Setting', current_user.id if api_key.save

    redirect_to '/' + user.username + '/setting/api'
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
  # if the request was doing for the user login
  #
  def find_owner
    user = User.find_by_username(params[:username]) || not_found
    return user if auth? && current_user.username == user.username || not_found
  end

  ##
  # Validate tabs when redirect is throw
  #
  def valid_tab?
    %w(account team api).any? { |word|  params[:val] == word }
  end
end
