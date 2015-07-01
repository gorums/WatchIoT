class ProjectRolUserPerm < ActiveRecord::Base
  has_many :projects
  has_many :project_rols
  has_many :users
end
