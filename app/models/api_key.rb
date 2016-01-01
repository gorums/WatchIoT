##
# ApiKey model
#
class ApiKey < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :api_key
  validates_uniqueness_of :api_key
end
