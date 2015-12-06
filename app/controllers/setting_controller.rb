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

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def profile_params
    params.require(:user).permit(:first_name, :last_name, :country_code,
                                 :address, :phone, :receive_notif_last_new)
  end

end
