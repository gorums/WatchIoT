require 'spec_helper'

describe "space_rol_user_perms/edit" do
  before(:each) do
    @space_rol_user_perm = assign(:space_rol_user_perm, stub_model(SpaceRolUserPerm,
      :id_user => 1,
      :id_space => 1
    ))
  end

  it "renders the edit space_rol_user_perm form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", space_rol_user_perm_path(@space_rol_user_perm), "post" do
      assert_select "input#space_rol_user_perm_id_user[name=?]", "space_rol_user_perm[id_user]"
      assert_select "input#space_rol_user_perm_id_space[name=?]", "space_rol_user_perm[id_space]"
    end
  end
end
