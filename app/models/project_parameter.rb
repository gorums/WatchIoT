# == Schema Information
#
# Table name: project_parameters
#
#  id         :integer          not null, primary key
#  name       :string
#  type_param :string
#  user_id    :integer
#  space_id   :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

##
# Project parameter model
#
class ProjectParameter < ActiveRecord::Base
  belongs_to :project
  belongs_to :space
  belongs_to :user
end
