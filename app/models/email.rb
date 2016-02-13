##
# Email model
#
class Email < ActiveRecord::Base
  belongs_to :user

  validates_uniqueness_of :email, scope: [:user_id]
  validates :email, email: true , presence: true

  scope :my_emails, -> user_id { where('user_id = ?', user_id).order(principal: :desc) }
  scope :my_email, -> user_id { where('user_id = ?', user_id).order(principal: :desc) }
  scope :has_email?, -> user_id, email { where('user_id = ?', user_id)
                                        .where('email = ?', email).exists? if email.present? }
  scope :find_email, -> user_id, email { where('user_id = ?', user_id)
                                            .where('email = ?', email).take if email.present? }

  scope :my_email_by_id, -> user_id, id { where('user_id = ?', user_id)
                                            .where('id = ?', id).take if id.present? }

  scope :is_principal?, -> email { where('email = ?', email).where(principal: true).exists? if email.present? }
  scope :find_principal, -> email { where('email = ?', email).where(principal: true).take if email.present? }
  scope :my_principal, -> user_id { where('user_id = ?', user_id).where(principal: true).take }

  ##
  # Add an email to the account unprincipal waiting for verification
  #
  def self.add_email(user_id, email)
    raise StandardError, 'The email already added' if has_email?(user_id, email)

    email = Email.new(email: email, user_id: user_id)
    email.save!
  end

  ##
  # Remove an email unprincipal
  #
  def self.remove_email(user_id, email_id)
    email = my_email_by_id(user_id, email_id)
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
    email = my_email_by_id(user_id, email_id)
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
  # Set this email id like principal
  #
  def self.principal(user_id, email_id)
    email = my_email_by_id(user_id, email_id)
    raise StandardError, 'The email is not valid' if email.nil?
    raise StandardError, 'The email has to be check' unless email.checked?
    raise StandardError, 'The email has not to be principal' if email.principal
    raise StandardError, 'The email is principal in other account' if Email.is_principal? email.email

    Email.unprincipal(email.user_id)
    email.update!(principal: true)
    email.email
  end

  ##
  # I forget my password process
  #
  def self.forget(email)
    email = Email.find_principal email
    raise StandardError, 'The email is not principal' if email.nil?
    email.user
  end

  ##
  # Define if the email can checked like principal
  #
  def self.email_to_activate(user_id, email_s)
    email = Email.find_email user_id, email_s
    raise StandardError, 'The email is not valid' if email.nil?
    raise StandardError, 'The email is principal in other account' if Email.is_principal? email.email
    email
  end

  ##
  # by other user
  #
  def self.email_to_check(user_id, email)
    email = Email.find_email user_id, email
    raise StandardError, 'The email is not valid' if email.nil?
    email
  end

  private

  ##
  # Find the principal email for this user and set it like not principal
  #
  def self.unprincipal(user_id)
    email_principal = Email.my_principal user_id
    email_principal.update!(principal: false) unless email_principal.nil?
  end
end
