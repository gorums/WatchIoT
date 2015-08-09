class SpaceRolsController < ApplicationController
  before_action :set_space_rol, only: [:show, :edit, :update, :destroy]

  # GET /space_rols
  # GET /space_rols.json
  def index
    @space_rols = SpaceRol.all
  end

  # GET /space_rols/1
  # GET /space_rols/1.json
  def show
  end

  # GET /space_rols/login
  def new
    @space_rol = SpaceRol.new
  end

  # GET /space_rols/1/edit
  def edit
  end

  # POST /space_rols
  # POST /space_rols.json
  def create
    @space_rol = SpaceRol.new(space_rol_params)

    respond_to do |format|
      if @space_rol.save
        format.html { redirect_to @space_rol, notice: 'Space rol was successfully created.' }
        format.json { render :show, status: :created, location: @space_rol }
      else
        format.html { render :new }
        format.json { render json: @space_rol.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /space_rols/1
  # PATCH/PUT /space_rols/1.json
  def update
    respond_to do |format|
      if @space_rol.update(space_rol_params)
        format.html { redirect_to @space_rol, notice: 'Space rol was successfully updated.' }
        format.json { render :show, status: :ok, location: @space_rol }
      else
        format.html { render :edit }
        format.json { render json: @space_rol.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /space_rols/1
  # DELETE /space_rols/1.json
  def destroy
    @space_rol.destroy
    respond_to do |format|
      format.html { redirect_to space_rols_url, notice: 'Space rol was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_space_rol
      @space_rol = SpaceRol.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def space_rol_params
      params.require(:space_rol).permit(:name, :description)
    end
end
