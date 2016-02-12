##
# Project controller
#
class ProjectsController < ApplicationController
  layout 'dashboard'

  before_filter :allow
  before_filter :allow_space
  
  ##
  # Get /:username/:space/:project
  #
  def index
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
