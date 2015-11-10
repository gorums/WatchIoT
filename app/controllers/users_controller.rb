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
    @email = Email.new
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @email = Email.new(email_params)

    if @user.save
      @email.user_id = @user.id;
      if @email.save
        #whether register fine, im going to login in the same time
        cookies[:auth_token] = @user.auth_token
        redirect_to root_url
      end
    else
      render :register
    end
  end

  def login
    @user = User.new
  end

  # POST /do_login
  def do_login
    user = User.authenticate(params[:email], params[:passwd])
    if user
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      redirect_to dashboard_url
    else
      flash.now.alert = "Invalid email or password"
      render :login
    end
  end
  def logout
    cookies.clear
    redirect_to root_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:passwd, :passwd_confirmation, :username)
    end

    def email_params
      params.require(:email).permit(:email)
    end
end
