class ProjectRolUserPermsController < ApplicationController
  before_action :set_project_rol_user_perm, only: [:show, :edit, :update, :destroy]

  # GET /project_rol_user_perms
  # GET /project_rol_user_perms.json
  def index
    @project_rol_user_perms = ProjectRolUserPerm.all
  end

  # GET /project_rol_user_perms/1
  # GET /project_rol_user_perms/1.json
  def show
  end

  # GET /project_rol_user_perms/new
  def new
    @project_rol_user_perm = ProjectRolUserPerm.new
  end

  # GET /project_rol_user_perms/1/edit
  def edit
  end

  # POST /project_rol_user_perms
  # POST /project_rol_user_perms.json
  def create
    @project_rol_user_perm = ProjectRolUserPerm.new(project_rol_user_perm_params)

    respond_to do |format|
      if @project_rol_user_perm.save
        format.html { redirect_to @project_rol_user_perm, notice: 'Project rol user perm was successfully created.' }
        format.json { render :show, status: :created, location: @project_rol_user_perm }
      else
        format.html { render :new }
        format.json { render json: @project_rol_user_perm.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_rol_user_perms/1
  # PATCH/PUT /project_rol_user_perms/1.json
  def update
    respond_to do |format|
      if @project_rol_user_perm.update(project_rol_user_perm_params)
        format.html { redirect_to @project_rol_user_perm, notice: 'Project rol user perm was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_rol_user_perm }
      else
        format.html { render :edit }
        format.json { render json: @project_rol_user_perm.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_rol_user_perms/1
  # DELETE /project_rol_user_perms/1.json
  def destroy
    @project_rol_user_perm.destroy
    respond_to do |format|
      format.html { redirect_to project_rol_user_perms_url, notice: 'Project rol user perm was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_rol_user_perm
      @project_rol_user_perm = ProjectRolUserPerm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_rol_user_perm_params
      params.require(:project_rol_user_perm).permit(:id_user, :id_project)
    end
end
