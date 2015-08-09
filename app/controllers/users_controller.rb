class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  # GET /users
  # GET /users.json
  # For ADMIN role
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  # For ADMIN role
  def show
  end

  # GET /register
  def register
    @user = User.new
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to root_url
    else
      render :register
    end
  end

  def login
    @user = User.new
  end

  #POST /do_login
  def do_login
    user = User.authenticate(params[:email], params[:passwd])
    if user
      session[:user_id] = user.id
      redirect_to root_url
    else
      flash.now.alert = "Invalid email or password"
      render :login
    end
  end
  def logout
    session[:user_id] = nil
    redirect_to root_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:passwd, :passwd_confirmation, :email)
    end
end
