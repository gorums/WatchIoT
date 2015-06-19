class SpaceRolUserPermsController < ApplicationController
  before_action :set_space_rol_user_perm, only: [:show, :edit, :update, :destroy]

  # GET /space_rol_user_perms
  # GET /space_rol_user_perms.json
  def index
    @space_rol_user_perms = SpaceRolUserPerm.all
  end

  # GET /space_rol_user_perms/1
  # GET /space_rol_user_perms/1.json
  def show
  end

  # GET /space_rol_user_perms/new
  def new
    @space_rol_user_perm = SpaceRolUserPerm.new
  end

  # GET /space_rol_user_perms/1/edit
  def edit
  end

  # POST /space_rol_user_perms
  # POST /space_rol_user_perms.json
  def create
    @space_rol_user_perm = SpaceRolUserPerm.new(space_rol_user_perm_params)

    respond_to do |format|
      if @space_rol_user_perm.save
        format.html { redirect_to @space_rol_user_perm, notice: 'Space rol user perm was successfully created.' }
        format.json { render :show, status: :created, location: @space_rol_user_perm }
      else
        format.html { render :new }
        format.json { render json: @space_rol_user_perm.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /space_rol_user_perms/1
  # PATCH/PUT /space_rol_user_perms/1.json
  def update
    respond_to do |format|
      if @space_rol_user_perm.update(space_rol_user_perm_params)
        format.html { redirect_to @space_rol_user_perm, notice: 'Space rol user perm was successfully updated.' }
        format.json { render :show, status: :ok, location: @space_rol_user_perm }
      else
        format.html { render :edit }
        format.json { render json: @space_rol_user_perm.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /space_rol_user_perms/1
  # DELETE /space_rol_user_perms/1.json
  def destroy
    @space_rol_user_perm.destroy
    respond_to do |format|
      format.html { redirect_to space_rol_user_perms_url, notice: 'Space rol user perm was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_space_rol_user_perm
      @space_rol_user_perm = SpaceRolUserPerm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def space_rol_user_perm_params
      params.require(:space_rol_user_perm).permit(:id_user, :id_space)
    end
end
