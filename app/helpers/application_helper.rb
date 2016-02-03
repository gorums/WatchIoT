module ApplicationHelper
  ##
  # This method return the principal email
  #
  def user_email(user_id)
    email = User.email(user_id) unless user_id.nil?
    email.email unless email.nil?
  end

  ##
  # This method return the principal email
  #
  def user_name(user_id)
    user = User.find(user_id) unless user_id.nil?
    user.username
  end
end
