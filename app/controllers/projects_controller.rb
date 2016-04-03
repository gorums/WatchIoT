# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  configuration :text
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
  before_filter :allow_project, :except => [:index, :create]

  ##
  # Get /:username/:space/projects
  #
  def index
    @project = Project.new
  end

  ##
  # Get /:username/:space/:project
  #
  def show
  end

  ##
  # Post /:username/:namespace/create
  #
  def create
    project = Project.create_new_project(project_create_params, @user, @space, me)

    flash_log('Create the project <b>' + project.name + '</b>',
              'Project was created correctly')

    redirect_to '/' + @user.username + '/' + @space.name + '/' + project.name
  rescue => ex
    flash[:error] = clear_exception ex.message
    redirect_to '/' + @user.username + '/' + @space.name
  end

  ##
  # Patch /:username/:namespace/:project
  #
  def edit
    @project.edit_project(project_edit_params[:description])

    flash_log('Edit the project <b>' + @project.name + '</b>', 'Project was edited correctly')
    redirect_to '/' + @user.username + '/' + @space.name + '/' + @project.name
  rescue => ex
    flash[:error] = clear_exception ex.message
    redirect_to '/' + @user.username + '/' + @space.name + '/' + @project.name
  end

  ##
  # Patch /:username/:namespace/:project/deploy
  #
  def deploy
    configuration = config_name_params[:configuration]

    respond_to do |format|
      format.html
      format.json
    end
  end

  ##
  # Patch /:username/:namespace/:project/evaluate
  #
  def evaluate
    @errors = Project.evaluate params[:configuration]
    respond_to do |format|
      if @errors.nil?
        flash.now[:notice] = 'All your code look fine!!! You can do deploy now!'
        format.js
      else
        format.json { render json: @errors  }
      end

      format.html { redirect_to '/' + @user.username + '/' + @space.name + '/' + @project.name }
    end
  rescue => ex
    flash.now[:error] = clear_exception ex.message
    respond_to do |format|
      format.js
      format.html { redirect_to '/' + @user.username + '/' + @space.name + '/' + @project.name }

    end
  end

  ##
  # Get /:username/:namespace/:project/setting
  #
  def setting
  end

  ##
  # Patch /:username/:namespace/:project/setting/change
  # Change space name
  #
  def change
    old_name = @project.name
    @project.change_project(project_name_params[:name])
    new_name = @project.name
    flash_log('Change project name <b>' + old_name + '</b> by <b>' + new_name + '</b>',
              'The project name was changed correctly')

    redirect_to '/' + @user.username + '/' + @space.name + '/' + new_name + '/setting'
  rescue => ex
    flash[:error] = clear_exception ex.message
    redirect_to '/' + @user.username + '/' + @space.name + '/' + old_name + '/setting'
  end

  ##
  # Delete /:username/:namespace/setting/delete
  #
  def delete
    @project.delete_project(project_name_params[:name])

    flash_log('Delete project <b>' + project_name_params[:name] + '</b>',
              'The project was deleted correctly')
    redirect_to '/' + @user.username + '/' + @space.name
  rescue => ex
    flash[:error] = clear_exception ex.message
    redirect_to '/' + @user.username + '/' + @space.name + '/' + @project.name + '/setting'
  end

  private

  ##
  # Never trust parameters from the scary internet, only allow the white list through.
  #
  def project_create_params
    params.require(:project).permit(:name, :description)
  end

  ##
  # Never trust parameters from the scary internet, only allow the white list through.
  #
  def project_edit_params
    params.require(:project).permit(:name, :description)
  end

  ##
  # Never trust parameters from the scary internet, only allow the white list through.
  #
  def project_name_params
    params.require(:project).permit(:name)
  end

  ##
  # Never trust parameters from the scary internet, only allow the white list through.
  #
  def config_name_params
    params.require(:project).permit(:configuration)
  end

  ##
  # Set flash and log
  #
  def flash_log(log_description, msg)
    save_log log_description, 'Project', @user.id
    flash[:notice] = msg
  end

end
