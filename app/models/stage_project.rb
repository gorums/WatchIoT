# == Schema Information
#
# Table name: stage_projects
#
#  id               :integer          not null, primary key
#  stage            :string(15)
#  notif_by_email   :boolean          default(TRUE)
#  notif_by_sms     :boolean          default(FALSE)
#  notif_by_webhook :boolean          default(FALSE)
#  user_id          :integer
#  space_id         :integer
#  project_id       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

##
# Stage project model
#
class StageProject < ActiveRecord::Base
  belongs_to :project
  belongs_to :space
  belongs_to :user
end
