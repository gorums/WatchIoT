# == Schema Information
#
# Table name: project_request_from_clients
#
#  id                 :integer          not null, primary key
#  ips                :string
#  project_request_id :integer
#

##
# Project request from client model
#
class ProjectRequestFromClient < ActiveRecord::Base
  belongs_to :project
  belongs_to :space
  belongs_to :user
end
