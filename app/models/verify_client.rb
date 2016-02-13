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

  def self.send_forgot_notification(username)
    user = User.find_by_username(username) || not_found
    email = user_email(user.id)
    # TODO: throw exception
    return if email.nil?
    token = VerifyClient.create_token(user.id, email, 'reset')
    Notifier.send_forget_passwd_email(user, token, email).deliver_later
  end
end
