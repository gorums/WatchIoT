##
# Plan model
#
class Plan < ActiveRecord::Base
  has_many :users
  has_many :plan_features

  ##
  # Got plan values for the permissions
  #
  def self.find_plan_value(plan_id, feature_name)
    feature = Feature.find_by_name(feature_name)
    return 0 if feature.nil?
    planFeature = PlanFeature.find_by_plan_and_feature(plan_id, feature.id).take
    return 0 if planFeature.nil?
    planFeature.value
  end
end
