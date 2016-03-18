# == Schema Information
#
# Table name: project_evaluators
#
#  id         :integer          not null, primary key
#  script     :text
#  user_id    :integer
#  space_id   :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

##
# Project evaluator model
#
class ProjectEvaluator < ActiveRecord::Base
  belongs_to :project
  belongs_to :space
  belongs_to :user
end
