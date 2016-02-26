##
# Email model
#
class Email < ActiveRecord::Base
  belongs_to :user

  validates :email, email: true , presence: true
  validates_uniqueness_of :email, scope: [:user_id],
                          message: 'The email already exist in your account'

  scope :find_by_user, -> user_id {
        where('user_id = ?', user_id).order(principal: :desc) }
  scope :count_by_user, -> user_id {
        where('user_id = ?', user_id).count }
  scope :find_principal_by_user, -> user_id {
        where('user_id = ?', user_id).where(principal: true) }
  scope :find_by_user_and_by_id, -> user_id, id {
        where('user_id = ?', user_id).where('id = ?', id) if id.present? }
  scope :find_principal_by_email, -> email {
        where('email = ?', email).where(principal: true) if email.present? }
  scope :find_by_user_and_by_email, -> user_id, email {
        where('user_id = ?', user_id).where('email = ?', email) if email.present? }


  ##
  # Add an email to the account unprincipal waiting for verification
  #
  def self.add_email(user_id, email)
    Email.create!(email: email, user_id: user_id)
  end

  ##
  # Set this email id like principal
  #
  def self.principal(user_id, email_id)
    email = find_by_user_and_by_id(user_id, email_id).take
    raise StandardError, 'The email is not valid' if email.nil?
    raise StandardError, 'The email has to be check' unless email.checked?
    raise StandardError, 'The email already is principal in your account' if email.principal
    raise StandardError, 'The email is principal in other '/
                           'account' if Email.find_principal_by_email(email.email).exists?

    # set like not principal if exist the current principal email
    Email.unprincipal(email.user_id)
    email.update!(principal: true)
    email
  end

  ##
  # Remove an email unprincipal
  #
  def self.remove_email(user_id, email_id)
    email = find_by_user_and_by_id(user_id, email_id)
    raise StandardError, 'The email is not valid' if email.nil?
    raise StandardError, 'The email can not be principal' if email.principal?

    email_str = email.email
    email.destroy!
    email_str # return email.email
  end

  ##
  # Send the verification email
  #
  def self.send_verify(user_id, email_id)
    email = find_by_user_and_by_id(user_id, email_id)
    raise StandardError, 'The email is not valid' if email.nil?
    raise StandardError, 'The email has to be uncheck' if email.checked?

    token = VerifyClient.create_token(user_id, email.email, 'verify_email')
    Notifier.send_verify_email(email.user, token, email.email).deliver_later
    email.email # return email.email
  end

  ##
  # Set the check email field like true
  #
  def self.email_verify(email, verifyClient)
    email.update!(checked: true)
    verifyClient.destroy!
  end

  ##
  # I forget my password process
  #
  def self.forget(email)
    email = Email.find_principal_by_email email
    raise StandardError, 'The email is not principal' if email.nil?
    email.user
  end

  ##
  # Define if the email can checked like principal
  #
  def self.email_to_activate(user_id, email_s)
    email = Email.find_by_user_and_by_email user_id, email_s
    raise StandardError, 'The email is not valid' if email.nil?
    raise StandardError, 'The email is principal in other account' if Email.is_principal? email.email
    email
  end

  ##
  # by other user
  #
  def self.email_to_check(user_id, email)
    email = Email.find_by_user_and_by_email user_id, email
    raise StandardError, 'The email is not valid' if email.nil?
    email
  end

  def self.save_email(email, user_id, checked)
    email.checked = checked
    email.principal = checked
    email.user_id = user_id
    email.save!
  end
  private

  ##
  # Find the principal email for this user and set it like not principal
  #
  def self.unprincipal(user_id)
    email_principal = Email.find_principal_by_user(user_id).take
    email_principal.update!(principal: false) unless email_principal.nil?
  end
end
