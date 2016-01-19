##
# Project controller
#
class ProjectsController < ApplicationController
  layout 'dashboard'

  ##
  # Get /:username/:space/:project
  #
  def index
    user = find_owner
    return if user.nil?
  end

  ##
  # Get /:username/:space/:project
  #
  def show
    user = find_owner
    return if user.nil?
  end

  ##
  # Get /:username/:space/:project/setting
  #
  def setting
    user = find_owner
    return if user.nil?
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
