##
# Chart controller
#
class ChartController < ApplicationController
  layout 'dashboard'

  ##
  # Get /:username/chart
  #
  def show
    user = find_owner
    return if user.nil?

  end

  ##
  # if the request was doing for the user login or an user team
  #
  def find_owner
    user = User.find_by_username(params[:username]) || not_found
    return user if auth? && current_user.username == user.username
    return user if Team.where(user_id: user.id).where(user_team_id: current_user.id).any?

    redirect_to :root
    nil
  end
end
