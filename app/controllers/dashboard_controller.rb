class DashboardController < ApplicationController

  layout 'dashboard'

  def index
    redirect_to :root if !is_auth?
  end

  def show
    user = User.find_by_username(params[:username])  or not_found

    if !is_auth? || current_user.username != user.username
      render 'general', layout: 'application'
    else
      render 'index'
    end
  end

end
