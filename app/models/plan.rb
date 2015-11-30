class Plan < ActiveRecord::Base
  has_many :users
  has_many :plan_features
end