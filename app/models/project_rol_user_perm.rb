class ProjectRolUserPerm < ActiveRecord::Base
  has_many :users
  has_many :projects
  has_many :project_rols
end
