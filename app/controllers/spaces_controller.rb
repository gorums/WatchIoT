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

    @space = Space.new
    @spaces = Space.where(user_id: user.id).order(created_at: :desc)
  end

  ##
  # Get /:username/:spacename
  #
  def show
    user = find_owner

    @space = find_space user
    @project = Project.new
  end

  ##
  # Post /:username/create
  #
  def create
    user = find_owner

    @space = Space.new(space_params)
    @space.user_id = user.id
    @space.user_owner_id = current_user.id

    save_log 'Create the space <b>' + @space.name + '</b>',
               'Space', user.id if @space.save

    redirect_to '/' + params[:username] + '/' + @space.name
  end

  ##
  # Patch /:username/:spacename/edit
  #
  def edit
    user = find_owner

    @space = find_space user

    save_log 'Edit the space <b>' + @space.name + '</b>',
               'Space', user.id if @space.update(space_edit_params)

    @project = Project.new
    render 'show'
  end

  ##
  # Get /:username/:spacename/setting
  #
  def setting
    user = find_owner

    @space = find_space user
    @teams = Team.where(user_id: user.id)
  end

  ##
  # Patch /:username/:spacename/setting/change
  #
  def change
    user = find_owner

    space = find_space user
    old_name = space.name

    save_log 'Change name space ' + old_name + ' by ' + space.name,
             'Space Setting', current_user.id if space.update(space_params)

    redirect_to '/' + user.username + '/' + space.name + '/setting'
  end

  ##
  # Patch /:username/:spacename/setting/transfer
  #
  def transfer
    user = find_owner
    # if my team member
    not_found unless my_team? user

    space = find_space user
    Space.transfer(space, params[:team_id])
    notifier_member(user, space)

    save_log 'Change the owner of space ' + space.name + ' to ' + user_email(user_id_team),
             'Space Setting', current_user.id if space.update!(user_id: user_id_team)

    redirect_to '/' + user.username + '/spaces'
  end

  ##
  # Delete /:username/:spacename/setting/delete
  #
  def delete
    user = find_owner
    # TODO: verify if exist project for tis space

    space = find_space user
    space.destroy!
    
    save_log 'Delete name space <b>' + params[:spacename] + '</b>',
             'Space Setting', current_user.id if space.destroyed?

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
  # If is one of my team users
  #
  def my_team?(user)
    Team.where(user_id: user.id).where(user_team_id: params[:team_id]).any?
  end

  ##
  # Get space to transfer
  #
  def find_space(user)
    Space.where(user_id: user.id).where(name: params[:spacename]).first || not_found
  end

  ##
  # Notifier member for transfer space with projects
  #
  def notifier_member(user, space)
    member_email = user_email(params[:team_id])
    # Notifier.send_signup_email(user, space, member_email).deliver_later unless member_email.nil?
  end
end
