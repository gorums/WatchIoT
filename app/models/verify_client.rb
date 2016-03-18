# == Schema Information
#
# Table name: verify_clients
#
#  id      :integer          not null, primary key
#  token   :string
#  data    :string
#  user_id :integer
#  concept :string
#

##
# Email model
#
class VerifyClient < ActiveRecord::Base
  belongs_to :user

  scope :find_by_token_and_concept, ->token, concept {
            where('token = ?', token).where('concept = ?', concept) }
  scope :find_by_user_and_concept, ->user_id, concept {
            where('user_id = ?', user_id).where('concept = ?', concept) }

  ##
  # Register customer verification
  #
  def self.create_token(user_id, email, concept)
    verifyClient = find_by_user_and_concept(user_id, concept).take
    verifyClient = VerifyClient.new if verifyClient.nil?

    verifyClient.data = email
    verifyClient.user_id = user_id
    verifyClient.concept = concept
    verifyClient.token = SecureRandom.uuid
    verifyClient.save!

    verifyClient.token
  end
end
