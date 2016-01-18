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

  ##
  # Patch /:username/:spacename/setting/chname
  #
  def chname
    user = find_owner
    return if user.nil?

    space = Space.where(user_id: user.id, name: params[:spacename]).first || not_found
    old_name = space.name
    save_log 'Change name space ' + old_name + ' by ' + space.name,
             'Setting Space', current_user.id if space.update(space_params)

    redirect_to '/' + user.username + '/' + space.name + '/setting'
  end

  ##
  # Patch /:username/:spacename/setting/transfer
  #
  def transfer
    user = find_owner
    return if user.nil?

    space = Space.where(user_id: user.id, name: params[:spacename]).first || not_found
    user_id_team = params[:team_id]
    return unless Team.where(user_id: user.id).where(user_team_id: user_id_team).any?

    save_log 'Change the owner of space ' + space.name + ' to ' + user_email(user_id_team),
             'Setting Space', current_user.id if space.update!(user_id: user_id_team)

    redirect_to '/' + user.username + '/spaces'
  end

  ##
  # Delete /:username/:spacename/setting/delete
  #
  def delete
    user = find_owner
    return if user.nil?

    # TODO: verify if exist project for tis space

    space = Space.where(user_id: user.id, name: params[:spacename]).first || not_found
    space.destroy!
    save_log 'Delete name space',
             'Setting Space', current_user.id if space.destroyed?

    redirect_to '/' + user.username + '/spaces'
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
    return user if Team.where(user_id: user.id).where(user_team_id: current_user.id).any?

    render 'general/spaces', layout: 'application'
    nil
  end
end
