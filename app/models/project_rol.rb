class ProjectRol < ActiveRecord::Base
  has_and_belongs_to_many :project_perms
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :users
end
