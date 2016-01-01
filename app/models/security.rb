##
# Security model
#
class Security < ActiveRecord::Base
  belongs_to :user
end
