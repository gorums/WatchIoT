# == Schema Information
#
# Table name: plans
#
#  id               :integer          not null, primary key
#  name             :string
#  amount_per_month :decimal(, )
#

##
# Plan model
#
class Plan < ActiveRecord::Base
  has_many :users
  has_many :plan_features

  ## -------------------- Instance method ----------------------- ##

  ##
  # Got plan values for the permissions
  #
  def find_plan_value(feature_name)
    feature = Feature.find_by_name(feature_name)
    return 0 if feature.nil?
    planFeature = PlanFeature.find_by_plan_and_feature(self.id, feature.id).take
    return 0 if planFeature.nil?
    planFeature.value
  end
end
