##
# ContactUs model
#
class ContactUs < ActiveRecord::Base
  validates_presence_of :email, :subject, :body, on: :create
  validates :email,
            format: { with: /\A[-a-z0-9_+\.]+@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i }
end
