class ApplicationMailer < ActionMailer::Base
  default from: 'info@watchiot.org'
  add_template_helper(ApplicationHelper)

  layout 'mailer'
end
