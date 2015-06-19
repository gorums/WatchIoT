require 'spec_helper'

describe "space_rol_user_perms/show" do
  before(:each) do
    @space_rol_user_perm = assign(:space_rol_user_perm, stub_model(SpaceRolUserPerm,
      :id_user => 1,
      :id_space => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
