require "spec_helper"

describe ProjectRolUserPermsController do
  describe "routing" do

    it "routes to #index" do
      get("/project_rol_user_perms").should route_to("project_rol_user_perms#index")
    end

    it "routes to #new" do
      get("/project_rol_user_perms/new").should route_to("project_rol_user_perms#new")
    end

    it "routes to #show" do
      get("/project_rol_user_perms/1").should route_to("project_rol_user_perms#show", :id => "1")
    end

    it "routes to #edit" do
      get("/project_rol_user_perms/1/edit").should route_to("project_rol_user_perms#edit", :id => "1")
    end

    it "routes to #create" do
      post("/project_rol_user_perms").should route_to("project_rol_user_perms#create")
    end

    it "routes to #update" do
      put("/project_rol_user_perms/1").should route_to("project_rol_user_perms#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/project_rol_user_perms/1").should route_to("project_rol_user_perms#destroy", :id => "1")
    end

  end
end
