##
# Space controller
#
class SpacesController < ApplicationController
  layout 'dashboard'

  ##
  # Get /:username/spaces
  #
  def index
    user = find_owner
    return if user.nil?

    @space = Space.new
    @spaces = Space.where(user_id: user.id).order(created_at: :desc)
  end

  ##
  # Get /:username/:spacename
  #
  def show
    user = find_owner
    return if user.nil?

    @space = Space.where(user_id: user.id, name: params[:spacename]).first || not_found
    @project = Project.new
  end

  ##
  # Post /:username/create
  #
  def create
    user = find_owner
    return if user.nil?

    @space = Space.new(space_params)
    @space.can_subscribe = @space.is_public
    @space.user_id = user.id
    @space.user_owner_id = current_user.id

    save_log 'Create the space <b>' + @space.name + '</b>',
               'Create Space', user.id if @space.save

    redirect_to '/' + params[:username] + '/' + @space.name
  end

  ##
  # Patch /:username/:spacename/edit
  #
  def edit
    user = find_owner
    return if user.nil?
    @space = Space.where(user_id: user.id, name: params[:spacename]).first || not_found

    @space.can_subscribe = params[:is_public] # fix: subscribe table
    save_log 'Edit the space <b>' + @space.name + '</b>',
               'Edit Space', user.id if @space.update(space_edit_params)

    @project = Project.new
    render 'show'
  end

  ##
  # Get /:username/:spacename/setting
  #
  def setting
    user = find_owner
    return if user.nil?
    @space = Space.where(user_id: user.id, name: params[:spacename]).first || not_found
    @teams = Team.where(user_id: user.id)
  end

  private

  ##
  # Never trust parameters from the scary internet, only allow the white list through.
  #
  def space_params
    params.require(:space).permit(:name, :description, :is_public)
  end

  ##
  # Never trust parameters from the scary internet, only allow the white list through.
  #
  def space_edit_params
    params.require(:space).permit(:description, :is_public)
  end

  ##
  # if the request was doing for the user login or an user team
  #
  def find_owner
    user = User.find_by_username(params[:username]) || not_found
    return user if auth? && current_user.username == user.username
    return user if Team.where(user_id: user.id).where(user_id_team: current_user.id).any?

    render 'general/spaces', layout: 'application'
    nil
  end
end
