class Permission < ActiveRecord::Base
  has_many :teams
  has_many :team_spaces
  has_many :team_projects

end