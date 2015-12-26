class SettingController < ApplicationController
  layout 'dashboard'

  ##
  # Get /:username/setting
  #
  def show
    redirect_to :root if !is_auth?
    user = User.find_by_username(params[:username])  or not_found

    if current_user.username != user.username
      redirect_to :root
    end

    @in = ''
  end

  ##
  # Patch  /:username/setting/profile
  #
  def profile
    redirect_to :root if !is_auth?
    user = User.find_by_username(params[:username])  or not_found

    if user.update(profile_params)
      save_log 'Edit the profile setting', 'Edit Profile', user.id
    end

    @in = 'profile'
    redirect_to '/' + user.username + '/setting#collapseProfile'
  end

  ##
  # Patch  /:username/setting/account/email/add
  #
  def account_email_add
    #TODO:
  end

  ##
  # Delete  /:username/setting/account/email/delete
  #
  def account_email_delete
    #TODO:
  end

  ##
  # Patch  /:username/setting/account/email/principal
  #
  def account_email_principal
    #TODO:
  end

  ##
  # Patch  /:username/setting/account/chusername
  #
  def account_ch_username
    #TODO:
  end

  ##
  # Patch  /:username/setting/account/chpassword
  #
  def account_ch_password
    #TODO:
  end

  ##
  # Delete  /:username/setting/account/delete
  #
  def account_delete
    #TODO:
  end

  ##
  # Patch  /:username/setting/plan/upgrade
  #
  def plan_upgrade
    #TODO:
  end

  ##
  # Patch  /:username/setting/team/add
  #
  def team_add
    #TODO:
  end

  ##
  # Delete  /:username/setting/team/delete
  #
  def team_delete
    #TODO:
  end

  ##
  # Patch  /:username/setting/team/permission
  #
  def team_permission
    #TODO:
  end

  ##
  # Patch  /:username/setting/key/generate
  #
  def key_generate
    #TODO:
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def profile_params
    params.require(:user).permit(:first_name, :last_name, :country_code,
                                 :address, :phone, :receive_notif_last_new)
  end

end
