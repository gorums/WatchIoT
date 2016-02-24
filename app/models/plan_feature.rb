##
# Plan feature model
#
class PlanFeature < ActiveRecord::Base
  belongs_to :plan
  belongs_to :feature

  scope :find_by_plan_and_feature, -> plan_id, feature_id { where('plan_id = ?', plan_id)
                                                .where('feature_id = ?', feature_id) }
end
