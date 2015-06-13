require 'test_helper'

class ProjectRolsControllerTest < ActionController::TestCase
  setup do
    @project_rol = project_rols(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_rols)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_rol" do
    assert_difference('ProjectRol.count') do
      post :create, project_rol: { description: @project_rol.description, name: @project_rol.name }
    end

    assert_redirected_to project_rol_path(assigns(:project_rol))
  end

  test "should show project_rol" do
    get :show, id: @project_rol
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project_rol
    assert_response :success
  end

  test "should update project_rol" do
    patch :update, id: @project_rol, project_rol: { description: @project_rol.description, name: @project_rol.name }
    assert_redirected_to project_rol_path(assigns(:project_rol))
  end

  test "should destroy project_rol" do
    assert_difference('ProjectRol.count', -1) do
      delete :destroy, id: @project_rol
    end

    assert_redirected_to project_rols_path
  end
end
