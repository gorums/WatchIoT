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
end
