class User < ActiveRecord::Base

  attr_accessor :passwd_confirmation

  has_many :spaces
  has_many :projects

  validates_confirmation_of :passwd
  validates_presence_of :passwd, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  validates :passwd, length: { minimum: 8 }
  validates :email, format: { with: /\A[-a-z0-9_+\.]+@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i }

  before_save :encrypt_password

  def encrypt_password
    if passwd.present?
      self.passwd_salt = BCrypt::Engine.generate_salt
      self.passwd = BCrypt::Engine.hash_secret(passwd, passwd_salt)
    end
  end

  def self.authenticate(email, passwd)
    user = find_by_email(email)
    if user && user.passwd == BCrypt::Engine.hash_secret(passwd, user.passwd_salt)
      user
    else
      nil
    end
  end

end
