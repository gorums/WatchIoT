# == Schema Information
#
# Table name: project_requests
#
#  id              :integer          not null, primary key
#  request_per_min :integer
#  way             :string
#  token           :string
#  user_id         :integer
#  space_id        :integer
#  project_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

##
# Project request
#
class ProjectRequest < ActiveRecord::Base
  belongs_to :project
  belongs_to :space
  belongs_to :user
end
