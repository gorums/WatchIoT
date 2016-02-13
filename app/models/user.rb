##
# User model
#
class User < ActiveRecord::Base
  attr_accessor :passwd_confirmation, :passwd_new

  has_many :emails
  has_many :spaces
  has_many :projects
  has_many :teams
  has_many :team_spaces
  has_many :team_projects
  has_many :securities
  has_many :logs
  has_many :stage_spaces
  has_many :stage_projects
  has_many :project_parameters
  has_many :project_requests
  has_many :project_webhooks
  has_many :project_evaluators
  has_many :verify_clients
  has_one :api_key
  has_one :plan

  validates_uniqueness_of :username
  validates :username, format: { without: /\s+/,
                                 message: 'No empty spaces admitted for the username.' } # dont space admitted
  validates_presence_of :username, on: :create
  validates_presence_of :passwd, on: :create
  validates_presence_of :passwd_confirmation, on: :create
  validates_confirmation_of :passwd

  validates :passwd, length: { minimum: 8 }

  validates :username, exclusion: { in: %w(home auth register verify login logout doc price download contact),
                                    message: '%{value} is reserved.' }

  before_create do
    generate_token(:auth_token)
    generate_api_key
    assign_plan
  end

  before_save :username_format

  ##
  # Disable the account
  #
  def self.account_delete(user, username)
    raise StandardError, 'The username is not valid' if user.username != username
    raise StandardError, 'You have to transfer or your spaces or delete their' if Space.has_spaces? user.id

    user.update!(statu: false)
  end

  ##
  # Find member to add the team
  #
  def self.find_member(user_id, email_member)
    emails = Email.where('email = ?', email_member).all
    # if dont exist create a new account
    return create_new_member(email_member) if emails.nil? || emails.empty?
    # if we find only one account
    return User.find(emails.first.user_id) if emails.length == 1
    # if we find more of one account, return the principal
    email = Email.find_principal email_member
    return User.find_by(id: email.user_id) unless email.nil?
  end

  ##
  # change the username
  #
  def self.change_username(user, new_username)
    user.update!(username: new_username)
  end

  ##
  # Change the password
  #
  def self.change_passwd(user, params)
    same_old_passwd =  user.passwd != BCrypt::Engine.hash_secret(params[:passwd], user.passwd_salt)
    raise StandardError, 'The old password is not correctly' unless same_old_passwd
    passwd_confirmation = params[:passwd_new] != params[:passwd_confirmation]
    raise StandardError, 'Password does not match the confirm password' unless passwd_confirmation

    user.update!(passwd: BCrypt::Engine.hash_secret(params[:passwd_new], user.passwd_salt))
  end

  def self.send_forgot_notification(username)
    user = User.find_by_username(username) || not_found
    email = user_email(user.id)
    # TODO: throw exception
    return if email.nil?
    token = VerifyClient.create_token(user.id, email, 'reset')
    Notifier.send_forget_passwd_email(user, token, email).deliver_later
  end

  def self.invite(user, user_params, verifyClient)
    email = Email.email_to_activate(verifyClient.user_id, verifyClient.data) || not_found

    user.username = user_params[:username]
    user.passwd = user_params[:passwd]
    user.passwd_confirmation = user_params[:passwd_confirmation]

    save_user_and_mail(user, email, true)
    cookies[:auth_token] = user.auth_token

    Notifier.send_signup_verify_email(user, email.email).deliver_later
    verifyClient.destroy!
  end

  def self.login(params)
    user = User.authenticate(params[:email], params[:passwd])
    return if user.nil?

    cookies.permanent[:auth_token] = user.auth_token if params[:remember_me]
    cookies[:auth_token] = user.auth_token unless params[:remember_me]
  end

  def self.omniauth
    auth = request.env['omniauth.auth']
    user = User.find_by_provider_and_uid(auth['provider'], auth['uid']) || User.create_with_omniauth(auth)

    cookies[:auth_token] = user.auth_token
  end

  def self.register(user_params)
    user = User.new(user_params)
    email = email_params[:email]

    User.transaction do
      begin
        #TODO: verificate passwd confirmation
        save_user_and_mail user, Email.new(email: email)
        token = VerifyClient.create_token(user.id, email, 'register')
        Notifier.send_signup_email(user, email, token).deliver_later
      rescue
        raise ActiveRecord::Rollback, 'Can register the account!'
      end
    end
  end

  ##
  # This method try to authenticate the client
  #
  def self.authenticate(email, passwd)
    return if passwd.empty?
    # find by email
    user_email = Email.where(email: email).where(principal: true).take

    user = user_email.user unless user_email.nil?
    # else find by username
    user = User.find_by_username(email) if user_email.nil?
    return if user.nil?

    user if user.status? && user.passwd == BCrypt::Engine.hash_secret(passwd, user.passwd_salt)
  end

  ##
  # Register with omniauth
  #
  def self.create_with_omniauth(auth)
    user = User.new
    user.provider = auth['provider']
    user.uid = auth['uid']
    user.first_name = first_name(auth['info']['name'])
    user.last_name = last_name(auth['info']['name'])
    user.username = auth['info']['nickname']
    user.passwd = generate_passwd

    email = Email.new
    email.email = auth['info']['email']
    save_user_and_mail user, email, true
    user
  end

  ##
  # Get the principal email
  #
  def self.email(user_id)
    email = Email.find_by user_id: user_id, principal: true
    email
  end

  ##
  # Get the api key
  #
  def self.api_key(api_key_id)
    api_key = ApiKey.find_by id: api_key_id
    api_key.api_key
  end

  ##
  # Change the password
  #
  def self.reset_passwd(user, params, verifyClient)
    return if user.passwd != BCrypt::Engine.hash_secret(params[:passwd], user.passwd_salt)
    return if params[:passwd_new] != params[:passwd_confirmation]

    verifyClient.destroy!
    user.update(passwd: BCrypt::Engine.hash_secret(params[:passwd_new], user.passwd_salt))
    true
  end

  ##
  # Save user and email routine
  #
  def self.save_user_and_mail(user, email, checked = false)
    user.passwd_salt = BCrypt::Engine.generate_salt
    user.passwd = BCrypt::Engine.hash_secret(user.passwd, user.passwd_salt)
    user.passwd_confirmation = user.passwd
    user.status = checked
    user.save!

    email.checked = checked
    email.principal = checked
    email.user_id = user.id
    email.save!
  end

  ##
  # Active the account after register and validate the email
  #
  def self.active_account(user, email, verifyClient)
    email.update(checked: true, principal: true)
    user.update(status: true)

    Notifier.send_signup_verify_email(user, email.email).deliver_later
    verifyClient.destroy!
    cookies[:auth_token] = user.auth_token
  end

  protected

  ##
  # This method generate a token for the client session
  #
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  ##
  # This method generate an api key for the client
  #
  def generate_api_key
    begin
      api_key = SecureRandom.uuid
    end while ApiKey.exists?(:api_key => api_key)

    api = ApiKey.new
    api.api_key = api_key
    api.save

    self.api_key_id = api.id
  end

  ##
  # This method assign the free plan by default
  #
  def assign_plan
    self.plan_id = 1
  end

  ##
  # Set username always lowercase
  # self.name.gsub! /[^0-9a-z ]/i, '_'
  #
  def username_format
    username.gsub! /[^0-9a-z\- ]/i, '_'
    username.downcase!
  end

  ##
  # Generate a randow password
  #
  def self.generate_passwd
    chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ0123456789'
    password = ''
    10.times { password << chars[rand(chars.size)] }
    password
  end

  private

  ##
  # Split first name
  #
  def self.first_name(name)
    name.split(' ').first
  end

  ##
  # Split last name
  #
  def self.last_name(name)
    name.split(' ', 2).last
  end

  ##
  # Create a new account member
  #
  def self.create_new_member(email_member)
    email = Email.new(email: email_member)

    password = User.generate_passwd
    user = User.new(username: email_member, passwd: password, passwd_confirmation: password)
    save_user_and_mail(user, email)

    token = VerifyClient.create_token(user.id, email_member, 'invited')
    Notifier.send_create_user_email(token, email_member).deliver_later
    user
  end
end
