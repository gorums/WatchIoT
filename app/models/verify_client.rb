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

  ##
  # Send forgot notification
  #
  def self.send_forgot_notification(username)
    user = User.find_by_username(username)
    user = find_user_by_email username if user.nil?
    raise StandardError, 'The account does not exist' if user.nil?

    email = Email.my_principal(user.id)
    raise StandardError, 'The account does not exist'  if email.nil?

    token = VerifyClient.create_token(user.id, email, 'reset')
    Notifier.send_forget_passwd_email(user, token, email).deliver_later
  end

  private

  def self.find_user_by_email(username)
    email = Email.find_principal username
    User.find(email.user_id) unless email.nil?
  end
end
