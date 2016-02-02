##
# Email model
#
class Email < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :email, on: :create
  validates_uniqueness_of :email, scope: [:user_id]
  validates :email,
            format: { with: /\A[-a-z0-9_+\.]+@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i }

  ##
  # Set this email id like principal
  #
  def self.principal(user_id, email_id)
    email = Email.where(id: email_id).where(user_id: user_id).take
    return if email.nil? || email.principal? || !email.checked?

    # find principal an check like unprincipal
    Email.unprincipal(user.id)

    email.update(principal: true)
  end

  ##
  # I forget my password process
  #
  def self.forget(email)
    email = Email.where(email: email).where(principal: true).take
    return email.user unless email.nil?
  end

  ##
  # Find the principal email for this user and set it like not principal
  #
  def self.unprincipal(user_id)
    email_principal = Email.where(principal: true)
                          .where(user_id: user_id).take

    return if email_principal.nil?
    email_principal.update(principal: false)
  end

  ##
  # Define if the email can checked like principal
  # TODO: throw exception if it can checked like principal because it is checked
  # by other user
  #
  def self.email_to_activate(user_id, email)
    emailObj = Email.find_by_email email
    return nil if emailObj.nil?
    return nil if emailObj.user_id != user_id && emailObj.principal?

    Email.where(email: email).where(user_id: user_id).take
  end

  ##
  # by other user
  #
  def self.email_to_check(user_id, email)
    Email.where(email: email).where(user_id: user_id).take
  end
end
