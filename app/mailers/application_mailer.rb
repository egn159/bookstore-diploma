class ApplicationMailer < ActionMailer::Base
  default from: ENV['HOSTNAME']
  layout 'mailer'
end
