class Email < ActiveRecord::Base

  belongs_to :user

  validates_presence_of :email, :on => :create
  validates_uniqueness_of :email
  validates :email, format: { with: /\A[-a-z0-9_+\.]+@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i }
end