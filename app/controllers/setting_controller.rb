class SettingController < ApplicationController
  layout 'dashboard'

  def index
    redirect_to :root if !is_auth?
  end

  def show
    redirect_to :root if !is_auth?
    @user = User.find_by_username(params[:username])
    render 'index'
  end
end
