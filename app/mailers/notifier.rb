class Notifier < ApplicationMailer
  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email(user, email, token)
    @user = user
    @token = token
    mail( :to => email,
          :subject => 'WatchIoT Account Activation' )
  end

  # send a transfer space email to the user
  def send_signup_verify_email(user, email)
    @user = user
    mail( :to => email,
          :subject => 'Transferred space for you!!')
  end

  # send a transfer space email to the user
  def send_transfer_space_email(user, space, email)
    @user = user
    @space = space
    mail( :to => email,
          :subject => 'Transferred space for you!!')
  end

  # send a new team member
  def send_new_team_email(user, email)
    @user = user
    mail( :to => email,
          :subject => 'Your belong a new team!!')
  end

  # send a new team member
  def send_create_user_email(token, email)
    @token = token
    mail( :to => email,
          :subject => 'Your belong a new team!!')
  end
end
