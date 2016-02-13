##
# Email model
#
class VerifyClient < ActiveRecord::Base
  belongs_to :user

  scope :find_token, ->token, concept {where('token = ?', token).where('concept = ?', concept).take }
  scope :find_verify, ->user_id, concept {where('user_id = ?', user_id).where('concept = ?', concept).take }

  ##
  # Register customer verification
  #
  def self.create_token(user_id, email, concept)
    verifyClient = find_verify user_id, concept
    verifyClient = VerifyClient.new if verifyClient.nil?

    verifyClient.data = email
    verifyClient.user_id = user_id
    verifyClient.concept = concept
    verifyClient.token = SecureRandom.uuid
    verifyClient.save!

    verifyClient.token
  end

end
