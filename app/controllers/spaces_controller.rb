# == Schema Information
#
# Table name: spaces
#
#  id            :integer          not null, primary key
#  name          :string
#  description   :text
#  is_public     :boolean          default(TRUE)
#  can_subscribe :boolean          default(TRUE)
#  user_id       :integer
#  user_owner_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

##
# Space controller
#
class SpacesController < ApplicationController
  layout 'dashboard'

  before_filter :allow
  before_filter :allow_space, :except => [:index, :create]

  ##
  # Get /:username/spaces
  #
  def index
    @space = Space.new
    @spaces = Space.find_by_user_order(@user.id).all
  end

  ##
  # Get /:username/:namespace
  #
  def show
    @project = Project.new
  end

  ##
  # Post /:username/create
  #
  def create
    space = Space.create_new_space(space_create_params, @user, me)

    flash_log('Create the space <b>' + space.name + '</b>',
              'Space created correctly')

    redirect_to '/' + @user.username + '/' + space.name
  rescue => ex
    flash[:error] = ex.message
    redirect_to '/' + @user.username + '/spaces'
  end

  ##
  # Patch /:username/:namespace
  #
  def edit
    render 'show'

    Space.edit_space(@space, space_edit_params[:description])
    @project = Project.new

    flash_log('Edit the space <b>' + @space.name + '</b>', 'Space edited correctly')    
  rescue => ex
    flash[:error] = ex.message
  end

  ##
  # Get /:username/:namespace/setting
  #
  def setting
    @teams = Team.my_teams @user.id
  end

  ##
  # Patch /:username/:namespace/setting/change
  # Change space name
  #
  def change
    redirect_to '/' + @user.username + '/' + @space.name + '/setting'

    old_name = @space.name
    Space.change_space(@space, space_edit_params[:name])

    flash_log('Change name space ' + old_name + ' by ' + @space.name,
              'The space name was hange correctly')
  rescue => ex
    flash[:error] = ex.message
  end

  ##
  # Patch /:username/:namespace/setting/transfer
  #
  def transfer
    redirect_to '/' + @user.username + '/spaces'

    Space.transfer @space, @user, params[:user_member_id]

    flash_log('Change the owner of space ' + @space.name + ' to ' + user_email(params[:user_member_id]),
              'The space was transfer correctly')
  rescue => ex
     if ex.message == 'You have a space with this name'
       flash[:error] = 'The team member has a space with this name'
     else
       flash[:error] = ex.message
     end
  end

  ##
  # Delete /:username/:namespace/setting/delete
  #
  def delete
    redirect_to '/' + @user.username + '/spaces'

    Space.delete_space(@space, space_name_params[:name])

    flash_log('Delete name space <b>' + space_name_params[:name] + '</b>',
              'The space was delete correctly')
  rescue => ex
    flash[:error] = ex.message
  end

  private

  ##
  # Never trust parameters from the scary internet, only allow the white list through.
  #
  def space_create_params
    params.require(:space).permit(:name, :description)
  end

  ##
  # Never trust parameters from the scary internet, only allow the white list through.
  #
  def space_name_params
    params.require(:space).permit(:name)
  end

  ##
  # Never trust parameters from the scary internet, only allow the white list through.
  #
  def space_edit_params
    params.require(:space).permit(:name, :description)
  end

  ##
  # Set flash and log
  #
  def flash_log(log_description, msg)
    save_log log_description, 'Space', @user.id
    flash[:notice] = msg
  end
end
