class Notifier < ApplicationMailer
  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email(user, email, token)
    @user = user
    @token = token
    mail( :to => email,
          :subject => 'WatchIoT Account Activation' )
  end

end
