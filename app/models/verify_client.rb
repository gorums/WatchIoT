##
# Email model
#
class VerifyClient < ActiveRecord::Base
  belongs_to :user

  ##
  # Register customer verification
  #
  def self.create_token(user_id, email, concept)
    verifyClient = VerifyClient.new
    verifyClient.data = email
    verifyClient.user_id = user_id
    verifyClient.concept = concept
    verifyClient.token = SecureRandom.uuid
    verifyClient.save!

    verifyClient.token
  end

end
