class SpaceRol < ActiveRecord::Base
  has_and_belongs_to_many :space_perms
  has_and_belongs_to_many :spaces
  has_and_belongs_to_many :users
end
