##
# Project request to server model
#
class ProjectRequestToServer < ActiveRecord::Base
  belongs_to :project
  belongs_to :space
  belongs_to :user
end
