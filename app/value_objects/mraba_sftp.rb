# frozen_string_literal: true

module MrabaSftp
  class << self
    def endpoint
      Settings.mraba_sftp.endpoint
    end

    def user
      Settings.mraba_sftp.user
    end

    def keys
      [Rails.application.secrets['some_secret']]
    end
  end
end
