require "spec_helper"

describe SpaceRolUserPermsController do
  describe "routing" do

    it "routes to #index" do
      get("/space_rol_user_perms").should route_to("space_rol_user_perms#index")
    end

    it "routes to #login" do
      get("/space_rol_user_perms/login").should route_to("space_rol_user_perms#login")
    end

    it "routes to #show" do
      get("/space_rol_user_perms/1").should route_to("space_rol_user_perms#show", :id => "1")
    end

    it "routes to #edit" do
      get("/space_rol_user_perms/1/edit").should route_to("space_rol_user_perms#edit", :id => "1")
    end

    it "routes to #create" do
      post("/space_rol_user_perms").should route_to("space_rol_user_perms#create")
    end

    it "routes to #update" do
      put("/space_rol_user_perms/1").should route_to("space_rol_user_perms#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/space_rol_user_perms/1").should route_to("space_rol_user_perms#destroy", :id => "1")
    end

  end
end
