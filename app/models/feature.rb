# == Schema Information
#
# Table name: features
#
#  id   :integer          not null, primary key
#  name :string
#

##
# Feature model
#
class Feature < ActiveRecord::Base
  has_many :plan_features
end
