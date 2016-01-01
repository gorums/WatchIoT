##
# Stage space model
#
class StageSpace < ActiveRecord::Base
  belongs_to :space
  belongs_to :user
end
