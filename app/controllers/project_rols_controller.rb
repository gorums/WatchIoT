class ProjectRolsController < ApplicationController
  before_action :set_project_rol, only: [:show, :edit, :update, :destroy]

  # GET /project_rols
  # GET /project_rols.json
  def index
    @project_rols = ProjectRol.all
  end

  # GET /project_rols/1
  # GET /project_rols/1.json
  def show
  end

  # GET /project_rols/login
  def new
    @project_rol = ProjectRol.new
  end

  # GET /project_rols/1/edit
  def edit
  end

  # POST /project_rols
  # POST /project_rols.json
  def create
    @project_rol = ProjectRol.new(project_rol_params)

    respond_to do |format|
      if @project_rol.save
        format.html { redirect_to @project_rol, notice: 'Project rol was successfully created.' }
        format.json { render :show, status: :created, location: @project_rol }
      else
        format.html { render :new }
        format.json { render json: @project_rol.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_rols/1
  # PATCH/PUT /project_rols/1.json
  def update
    respond_to do |format|
      if @project_rol.update(project_rol_params)
        format.html { redirect_to @project_rol, notice: 'Project rol was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_rol }
      else
        format.html { render :edit }
        format.json { render json: @project_rol.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_rols/1
  # DELETE /project_rols/1.json
  def destroy
    @project_rol.destroy
    respond_to do |format|
      format.html { redirect_to project_rols_url, notice: 'Project rol was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_rol
      @project_rol = ProjectRol.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_rol_params
      params.require(:project_rol).permit(:name, :description)
    end
end
