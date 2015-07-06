class SpaceRolUserPerm < ActiveRecord::Base
  belongs_to :user
  belongs_to :space
  belongs_to :space_rol
  belongs_to :space_perm
end
