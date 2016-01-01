##
# Project controller
#
class ProjectsController < ApplicationController
  layout 'dashboard'

  ##
  # Get /:username/:space/:project
  #
  def index
    user = User.find_by_username(params[:username])  or not_found

    if !is_auth? || current_user.username != user.username
      render 'general/projects', layout: 'application'
      return
    end
  end

  ##
  # Get /:username/:space/:project
  #
  def show
  end

  ##
  # Get /:username/:space/:project/setting
  #
  def setting
  end
end
