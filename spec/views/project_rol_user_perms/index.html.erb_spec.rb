require 'spec_helper'

describe "project_rol_user_perms/index" do
  before(:each) do
    assign(:project_rol_user_perms, [
      stub_model(ProjectRolUserPerm,
        :id_user => 1,
        :id_project => 2
      ),
      stub_model(ProjectRolUserPerm,
        :id_user => 1,
        :id_project => 2
      )
    ])
  end

  it "renders a list of project_rol_user_perms" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
