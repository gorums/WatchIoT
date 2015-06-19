require 'spec_helper'

describe "project_rol_user_perms/edit" do
  before(:each) do
    @project_rol_user_perm = assign(:project_rol_user_perm, stub_model(ProjectRolUserPerm,
      :id_user => 1,
      :id_project => 1
    ))
  end

  it "renders the edit project_rol_user_perm form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", project_rol_user_perm_path(@project_rol_user_perm), "post" do
      assert_select "input#project_rol_user_perm_id_user[name=?]", "project_rol_user_perm[id_user]"
      assert_select "input#project_rol_user_perm_id_project[name=?]", "project_rol_user_perm[id_project]"
    end
  end
end
