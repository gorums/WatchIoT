##
# Dashboard controller
#
class DashboardController < ApplicationController
  layout 'dashboard'

  ##
  # Get /:username
  #
  def show
    user = find_owner
    return if user.nil?

    @space = Space.new
    @logs = Log.where(user_id: user.id).limit(20)
                .order(created_at: :desc)
  end

  private

  ##
  # if the request was doing for the user login or an user team
  #
  def find_owner
    user = User.find_by_username(params[:username]) || not_found
    return user if auth? && current_user.username == user.username
    return user if Team.where(user_id: current_user.id).where(user_id_team: user.id).any?

    redirect_to :root
    nil
  end
end
