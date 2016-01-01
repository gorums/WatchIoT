##
# Project request from client model
#
class ProjectRequestFromClient < ActiveRecord::Base
  belongs_to :project
  belongs_to :space
  belongs_to :user
end
