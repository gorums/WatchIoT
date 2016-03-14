##
# Email model
#
class Email < ActiveRecord::Base
  belongs_to :user

  validates :email, email: true , presence: true
  validates_uniqueness_of :email, scope: [:user_id],
                          message: 'The email already exist in your account'

  before_validation :downcase_email

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
    raise StandardError, 'is not a valid user id' unless
        User.where('id=?', user_id).exists?
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
    raise StandardError, 'The email is principal in other '\
                         'account' if Email.find_principal_by_email(email.email).exists?

    # set like not principal if exist the current principal email
    Email.unprincipal(user_id)
    email.update!(principal: true)
    email
  end

  ##
  # Remove an email unprincipal
  #
  def self.remove_email(user_id, email_id)
    email = find_by_user_and_by_id(user_id, email_id).take
    raise StandardError, 'The email is not valid' if email.nil?
    raise StandardError, 'You can not delete the only email '\
                         'in your account' if Email.count_by_user(user_id) == 1
    raise StandardError, 'The email can not be principal' if email.principal?

    email.destroy!
  end

  ##
  # Set the check email field like true
  #
  def self.email_verify(email)
    email.update!(checked: true)
  end

  ##
  # Send the verification email
  #
  def self.send_verify(user_id, email_id)
    email = find_by_user_and_by_id(user_id, email_id).take
    raise StandardError, 'The email is not valid' if email.nil?
    raise StandardError, 'The email has to be uncheck' if email.checked?

    token = VerifyClient.create_token(user_id, email.email, 'verify_email')
    Notifier.send_verify_email(email.email, email.user, token).deliver_later
    email
  end

  ##
  # Define if the email can checked like principal
  #
  def self.email_to_activate(user_id, email_s)
    email = Email.find_principal_by_email(email_s).take
    raise StandardError, 'The email is not valid' unless email.nil?
    email = Email.find_by_user_and_by_email(user_id, email_s).take
    raise StandardError, 'The email is not valid' if email.nil?
    email
  end

  ##
  # by other user
  #
  def self.email_to_check(user_id, email)
    email = Email.find_by_user_and_by_email(user_id, email).take
    raise StandardError, 'The email is not valid' if email.nil?
    email
  end

  ##
  # Update the email record
  #
  def self.save_email(email, user_id, checked)user_id
    email.update!(user_id: user_id, checked: checked, principal: checked)
  end

  ##
  # find an email to send an email
  #
  def self.find_email_forgot (email_s)
    emails = Email.where(email: email_s).all
    return if emails.nil? || emails.empty?
    return emails.first if emails.length == 1

    emails.each do |email|
      user = email.user
      return email if user.emails.length == 1 && !email.principal?
    end
  end

  protected

  ##
  # Downcase email
  #
  def downcase_email
    self.email = self.email.downcase unless self.email.nil?
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
