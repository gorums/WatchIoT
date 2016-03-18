# == Schema Information
#
# Table name: project_request_to_servers
#
#  id                 :integer          not null, primary key
#  url                :string
#  method             :string
#  content_type       :string
#  raw                :string
#  project_request_id :integer
#

##
# Project request to server model
#
class ProjectRequestToServer < ActiveRecord::Base
  belongs_to :project
  belongs_to :space
  belongs_to :user
end
