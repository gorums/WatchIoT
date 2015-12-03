class ProjectsController < ApplicationController
  layout 'dashboard'

  def index
    user = User.find_by_username(params[:username])  or not_found

    if !is_auth? || current_user.username != user.username
      render 'general/projects', layout: 'application'
      return
    end
  end

  def show

  end

  def setting

  end

end
