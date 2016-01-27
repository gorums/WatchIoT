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

end
