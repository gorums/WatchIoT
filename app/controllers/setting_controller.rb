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
    return if user.nil?

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
    return if user.nil?

    save_log 'Edit the profile setting',
             'Edit Profile', current_user.id if user.update(profile_params)

    redirect_to '/' + user.username + '/setting'
  end

  ##
  # Post /:username/setting/account/email/add
  #
  def account_email_add
    user = find_owner
    return if user.nil?

    email = Email.new(email_params)
    email.user_id = current_user.id
    email.principal = false

    save_log 'Add new email',
             'Edit Account', current_user.id if email.save

    redirect_to '/' + current_user.username + '/setting/account'
  end

  ##
  # Delete /:username/setting/account/email/delete/:id
  #
  def account_email_delete
    user = find_owner
    return if user.nil?

    email = Email.where(id: params[:id]).where(user_id: user.id).take
    email.destroy unless email.nil? || email.principal?

    redirect_to '/' + current_user.username + '/setting/account'
  end

  ##
  # Get /:username/setting/account/email/principal/:id
  #
  def account_email_principal
    user = find_owner
    return if user.nil?

    Email.principal(user.id, params[:id])
    save_log 'Set email like pincipal', 'Principal Email', current_user.id

    redirect_to '/' + current_user.username + '/setting/account'
  end

  ##
  # Patch /:username/setting/account/chpassword
  #
  def account_ch_password
    user = find_owner
    return if user.nil?

    User.change_passwd user, passwd_params

    save_log 'Change password', 'Edit Account', current_user.id

    redirect_to '/' + current_user.username + '/setting/account'
  end


  ##
  # Patch /:username/setting/account/chusername
  #
  def account_ch_username
    user = find_owner
    return if user.nil?

    save_log 'Change username',
             'Edit Account', current_user.id if user.update(username_params)

    redirect_to '/' + user.username + '/setting/account'
  end

  ##
  # Delete /:username/setting/account/delete
  #
  def account_delete
    user = find_owner
    return if user.nil?

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
    return if user.nil?

    email = Email.where(member_params).take
    user_member = User.find_by id: email.user_id unless email.nil?

    if email.nil?
      email = Email.new(member_params)
    end

    if user_member.nil?
      user_member = User.new
      user_member.username = email.email
      user_member.passwd = 'asdqwe123'
      user_member.passwd_confirmation = 'asdqwe123'
      User.save_user_and_mail(user_member, email)
    end

    team = Team.new
    team.user_id = user.id
    team.user_team_id = user_member.id
    save_log 'Adding a new member',
             'Update team', current_user.id if team.save

    redirect_to '/' + user.username + '/setting/team'
  end

  ##
  # Delete /:username/setting/team/delete
  #
  def team_delete
    user = find_owner
    return if user.nil?

    user_member = User.find params[:id]

    team = Team.where(user_id: user.id).where(user_team_id: user_member.id).take unless user_member.nil?
    Team.destroy(team.id) unless team.nil?

    redirect_to '/' + user.username + '/setting/team'
  end

  ##
  # Patch /:username/setting/key/generate
  #
  def key_generate
    user = find_owner
    return if user.nil?

    begin
      api_key_uuid = SecureRandom.uuid
    end while ApiKey.exists?(:api_key => api_key_uuid)

    api_key = ApiKey.find_by_id user.api_key_id;
    api_key.api_key = api_key_uuid
    save_log 'Change api key',
             'Edit Account', current_user.id if api_key.save

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
    return user if auth? && current_user.username == user.username

    redirect_to :root
    nil
  end

  ##
  # Validate tabs when redirect is throw
  #
  def valid_tab?
    %w(account team api).any? { |word|  params[:val] == word }
  end
end
