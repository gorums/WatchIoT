require 'test_helper'

class SpaceRolsControllerTest < ActionController::TestCase
  setup do
    @space_rol = space_rols(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:space_rols)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create space_rol" do
    assert_difference('SpaceRol.count') do
      post :create, space_rol: { description: @space_rol.description, name: @space_rol.name }
    end

    assert_redirected_to space_rol_path(assigns(:space_rol))
  end

  test "should show space_rol" do
    get :show, id: @space_rol
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @space_rol
    assert_response :success
  end

  test "should update space_rol" do
    patch :update, id: @space_rol, space_rol: { description: @space_rol.description, name: @space_rol.name }
    assert_redirected_to space_rol_path(assigns(:space_rol))
  end

  test "should destroy space_rol" do
    assert_difference('SpaceRol.count', -1) do
      delete :destroy, id: @space_rol
    end

    assert_redirected_to space_rols_path
  end
end
