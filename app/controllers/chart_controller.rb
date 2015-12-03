class ChartController < ApplicationController
  layout 'dashboard'

  def show
    user = User.find_by_username(params[:username])  or not_found

    if !is_auth? || current_user.username != user.username
      render 'general/chart', layout: 'application'
      return
    end
  end
end
