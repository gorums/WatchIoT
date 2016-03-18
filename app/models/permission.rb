# == Schema Information
#
# Table name: permissions
#
#  id         :integer          not null, primary key
#  category   :string
#  permission :string
#

##
# Permission model
#
class Permission < ActiveRecord::Base
  has_many :teams
  has_many :team_spaces
  has_many :team_projects
end
