class ApplicationMailer < ActionMailer::Base
  #include Roadie::Rails::Automatic

  default from: 'info@watchiot.com'
  add_template_helper(UsersHelper)

  layout 'mailer'
end
