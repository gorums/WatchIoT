class SpaceRolUserPerm < ActiveRecord::Base
  has_many :users
  has_many :spaces
  has_many :space_rols
end
