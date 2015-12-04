class DashboardController < ApplicationController
  layout 'dashboard'

  def show
    owner_user = User.find_by_username(params[:username])  or not_found

    if !is_auth? || current_user.username != owner_user.username
      render 'general/dashboard', layout: 'application'
    else
      @space = Space.new
      @logs = Log.where(user_id: owner_user.id).find_each
      render 'show'
    end


  end

end
