##
# Dashboard controller
#
class DashboardController < ApplicationController
  layout 'dashboard'

  ##
  # Get /:username
  #
  def show
    user = User.find_by_username(params[:username]) || not_found
    is_me = auth? && current_user.username == user.username
    iam_in_team  = auth? && Team.where(user_id: user.id).where(user_team_id: current_user.id).any?

    if is_me || iam_in_team
      @space = Space.new
      @logs = Log.where(user_id: user.id).limit(20)
                  .order(created_at: :desc)
    else
      redirect_to :root
    end
  end
end
