class ProjectRolUserPerm < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :project_rol
  belongs_to :project_perm
end
