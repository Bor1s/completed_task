# frozen_string_literal: true

class DownloadFile
  START_EXT = '.start'
  attr_reader :sftp, :local_file, :remote_file, :entry
  private :sftp, :local_file, :remote_file

  def initialize(sftp, entry)
    @sftp = sftp
    @entry = entry
    @local_file = "#{Rails.root}/private/data/download/#{entry}"
    @remote_file = "/data/files/csv/#{entry}#{START_EXT}"
  end

  def call
    Net::SFTP.start(sftp) do |sftp|
      sftp.download!(remote_file, local_file)
      sftp.remove!(remote_file)
    end
  end
end
