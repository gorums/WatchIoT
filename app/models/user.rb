class User < ActiveRecord::Base
  attr_accessor :passwd_confirmation

  before_save :encrypt_password

  validates_confirmation_of :passwd
  validates_presence_of :passwd, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email

  def self.authenticate(email, passwd)
    user = find_by_email(email)
    p = BCrypt::Engine.hash_secret(passwd, user.passwd_salt)
    if user && user.passwd == p
      user
    else
      nil
    end
  end

  def encrypt_password
    if passwd.present?
      self.passwd_salt = BCrypt::Engine.generate_salt
      self.passwd = BCrypt::Engine.hash_secret(passwd, passwd_salt)
    end
  end
end
