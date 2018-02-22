class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def self.send_import_feedback(message)
    # TODO: send some message
  end
end
