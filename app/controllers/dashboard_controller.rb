##
# Dashboard controller
#
class DashboardController < ApplicationController
  layout 'dashboard'

  ##
  # Get /:username
  #
  def show
    owner_user = User.find_by_username(params[:username]) || not_found

    if !auth? || current_user.username != owner_user.username
      render 'general/dashboard', layout: 'application'
    else
      @space = Space.new
      @logs = Log.where(user_id: owner_user.id).limit(20)
                  .order(created_at: :desc)
      render 'show'
    end
  end
end
