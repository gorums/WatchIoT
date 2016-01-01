##
# Project webhook model
#
class ProjectWebhook < ActiveRecord::Base
  belongs_to :project
  belongs_to :space
  belongs_to :user
end
