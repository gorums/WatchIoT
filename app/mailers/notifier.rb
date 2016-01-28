class Notifier < ApplicationMailer
  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_signup_email(user, email)
    @user = user
    mail( :to => email,
          :subject => 'Thanks for signing up for our amazing app' )
  end

end
