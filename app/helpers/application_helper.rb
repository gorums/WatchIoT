module ApplicationHelper
  ##
  # This method return the principal email
  #
  def user_email(user_id)
    Email.my_principal user_id  || ''
  end

  ##
  # This method return the username
  #
  def user_name(user_id)
    user = User.find(user_id)
    user.username unless user.nil?
  end
end
