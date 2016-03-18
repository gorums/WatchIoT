# == Schema Information
#
# Table name: api_keys
#
#  id      :integer          not null, primary key
#  api_key :string
#  user_id :integer
#

##
# ApiKey model
#
class ApiKey < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :api_key
  validates_uniqueness_of :api_key

  def self.generate(user)
    begin
      api_key_uuid = SecureRandom.uuid
    end while ApiKey.exists?(:api_key => api_key_uuid)

    api_key = ApiKey.find_by_id! user.api_key_id
    api_key.api_key = api_key_uuid

    api_key.save!
  end
end
