# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string(25)
#  first_name             :string(25)
#  last_name              :string(35)
#  address                :text
#  country_code           :string(3)
#  phone                  :string(15)
#  status                 :boolean          default(TRUE)
#  receive_notif_last_new :boolean          default(TRUE)
#  passwd                 :string
#  passwd_salt            :string
#  auth_token             :string
#  provider               :string
#  uid                    :string
#  plan_id                :integer
#  api_key_id             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

module UsersHelper
  ##
  # This method return the primary email
  #
  def user_email(user_id)
    email = Email.find_primary_by_user(user_id).take
    email.email unless email.nil?
  end

  ##
  # This method return the username
  #
  def user_name(user_id)
    user = User.find(user_id)
    user.username unless user.nil?
  end
end
