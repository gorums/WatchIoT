# == Schema Information
#
# Table name: project_webhooks
#
#  id         :integer          not null, primary key
#  url        :string
#  token      :string
#  user_id    :integer
#  space_id   :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

##
# Project webhook model
#
class ProjectWebhook < ActiveRecord::Base
  belongs_to :project
  belongs_to :space
  belongs_to :user
end
