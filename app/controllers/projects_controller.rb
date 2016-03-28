# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  user_id       :integer
#  space_id      :integer
#  user_owner_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

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
