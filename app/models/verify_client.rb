##
# Email model
#
class VerifyClient < ActiveRecord::Base
  belongs_to :user

  ##
  # Register customer verification
  #
  def self.register(user_id, email)
    verifyClient =  VerifyClient.new
    verifyClient.data = email
    verifyClient.user_id = user_id
    verifyClient.token = SecureRandom.uuid
    verifyClient.save!

    verifyClient.token
  end
end
