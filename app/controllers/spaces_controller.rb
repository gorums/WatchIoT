class SpacesController < ApplicationController
  layout 'dashboard'

  def index
    user = User.find_by_username(params[:username])  or not_found

    if !is_auth? || current_user.username != user.username
      render 'general/spaces', layout: 'application'
      return
    end

    @space = Space.new
  end

  def create
    owner_user = User.find_by_username(params[:username])  or not_found

    @space = Space.new(space_params)
    @space.can_subscribe = @space.is_public
    @space.user_id = owner_user.id
    @space.user_owner_id = current_user.id

    if @space.save
      redirect_to params[:username] + '/show/' + @space.name
    end

    render :index
  end

  def show

  end

  def setting

  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
  def space_params
    params.require(:space).permit(:name, :description, :is_public)
  end
end
