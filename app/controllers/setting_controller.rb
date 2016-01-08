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

    @in = ''
  end

  ##
  # Patch /:username/setting/profile
  #
  def profile
    user = find_owner
    return if user.nil?

    save_log 'Edit the profile setting',
             'Edit Profile', current_user.id if user.update(profile_params)

    @in = 'profile'
    redirect_to '/' + user.username + '/setting#collapseProfile'
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

    @in = 'account'
    redirect_to '/' + current_user.username + '/setting#collapseAccount'
  end

  ##
  # Delete /:username/setting/account/email/delete/:id
  #
  def account_email_delete
    user = find_owner
    return if user.nil?

    email_id = params[:id]
    email = Email.where(id: email_id).where(user_id: user.id).take

    email.destroy unless email == nil || email.principal?

    @in = 'account'
    redirect_to '/' + current_user.username + '/setting#collapseAccount'
  end

  ##
  # Get /:username/setting/account/email/principal/:id
  #
  def account_email_principal
    user = find_owner
    return if user.nil?

    email_id = params[:id]
    email = Email.where(id: email_id).where(user_id: user.id).take

    if !email.nil? && !email.principal?
      # find principal an check like unprincipal
      email_principal = Email.where(principal: true)
                            .where(user_id: user.id).take
      if !email_principal.nil?
        email_principal.principal = false
        email_principal.save
      end

      email.principal = true
      email.save
    end

    @in = 'account'
    redirect_to '/' + current_user.username + '/setting#collapseAccount'
  end

  ##
  # Patch /:username/setting/account/chpassword
  #
  def account_ch_password
    user = find_owner
    return if user.nil?

    User.change_passwd user, passwd_params

    save_log 'Change password', 'Edit Account', current_user.id

    @in = 'account'
    redirect_to '/' + current_user.username + '/setting#collapseAccount'
  end


  ##
  # Patch /:username/setting/account/chusername
  #
  def account_ch_username
    user = find_owner
    return if user.nil?

    save_log 'Change username',
             'Edit Account', current_user.id if user.update(username_params)

    @in = 'account'
    redirect_to '/' + user.username + '/setting#collapseAccount'
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
  # Patch /:username/setting/plan/upgrade
  #
  def plan_upgrade
    user = find_owner
    return if user.nil?

    # TODO:
  end

  ##
  # Patch /:username/setting/team/add
  #
  def team_add
    user = find_owner
    return if user.nil?

    # TODO:
  end

  ##
  # Delete /:username/setting/team/delete
  #
  def team_delete
    user = find_owner
    return if user.nil?

    # TODO:
  end

  ##
  # Patch /:username/setting/team/permission
  #
  def team_permission
    user = find_owner
    return if user.nil?

    # TODO:
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
    api_key.save

    @in = 'api'
    redirect_to '/' + user.username + '/setting#collapseApiKey'
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
  # if the request was doing for the user login
  #
  def find_owner
    user = User.find_by_username(params[:username]) || not_found
    return user if auth? && current_user.username == user.username

    redirect_to :root
    nil
  end
end
