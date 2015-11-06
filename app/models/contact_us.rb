class ContactUs < ActiveRecord::Base

  validates_presence_of :email
  validates_presence_of :subject
  validates_presence_of :body
  validates :email, format: { with: /\A[-a-z0-9_+\.]+@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i }

end