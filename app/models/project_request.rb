##
# Project request
#
class ProjectRequest < ActiveRecord::Base
  belongs_to :project
  belongs_to :space
  belongs_to :user
end
