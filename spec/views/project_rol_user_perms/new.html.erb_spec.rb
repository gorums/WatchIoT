require 'spec_helper'

describe "project_rol_user_perms/login" do
  before(:each) do
    assign(:project_rol_user_perm, stub_model(ProjectRolUserPerm,
      :id_user => 1,
      :id_project => 1
    ).as_new_record)
  end

  it "renders login project_rol_user_perm form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", project_rol_user_perms_path, "post" do
      assert_select "input#project_rol_user_perm_id_user[name=?]", "project_rol_user_perm[id_user]"
      assert_select "input#project_rol_user_perm_id_project[name=?]", "project_rol_user_perm[id_project]"
    end
  end
end
