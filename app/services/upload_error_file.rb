# frozen_string_literal: true

class UploadErrorFile
  LOCAL_PATH = "#{Rails.root}/private/data/upload"

  attr_reader :entry, :file, :message, :remote_path
  private :entry, :file, :message, :remote_path

  def initialize(sftp, entry, message)
    @sftp = sftp
    @entry = entry
    @file = "#{Rails.root}/private/data/upload/#{entry}"
    @remote_path = "/data/files/batch_processed/#{entry}"
    @message = message
  end

  def call
    create_private_dir
    write_tmp_file
    upload_file
  end

  private

  def create_private_dir
    FileUtils.mkdir_p LOCAL_PATH
  end

  def write_tmp_file
    File.open(file, 'w') do |f|
      f.write(message)
    end
  end

  def upload_file
    Net::SFTP.start(sftp.endpoint, sftp.user, keys: sftp.keys) do |sftp|
      sftp.upload!(file, remote_path)
    end
  end
end
