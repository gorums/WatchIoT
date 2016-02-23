##
# Plan model
#
class Plan < ActiveRecord::Base
  has_many :users
  has_many :plan_features

  ##
  # Got plan values for the permissions
  #
  def self.plan_value(plan_id, feature_name)
    feature = Feature.find_by_name(feature_name)
    planFeature = PlanFeature.my_value(plan_id, feature.id).take
    planFeature.value
  end
end
