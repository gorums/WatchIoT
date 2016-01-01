##
# Project evaluator model
#
class ProjectEvaluator < ActiveRecord::Base
  belongs_to :project
  belongs_to :space
  belongs_to :user
end
