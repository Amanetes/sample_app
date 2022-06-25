# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'user@realdomain.com' # replace with real email for use in production
  layout 'mailer'
end
