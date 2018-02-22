# frozen_string_literal: true

class HandleEntry
  START_EXT = '.start'
  attr_reader :sftp, :local_file, :remote_file, :mailer, :entry
  private :sftp, :local_file, :remote_file, :mailer

  def initialize(sftp, entry, _mailer = ApplicationMailer)
    @sftp = sftp
    @entry = entry
    @local_file = "#{Rails.root}/private/data/download/#{entry}"
    @remote_file = "/data/files/csv/#{entry}"
  end

  def call
    sftp.download!(remote_file, local_file)
    sftp.remove!(remote_file + START_EXT)

    importer = ImportFile.new(local_file).call
    importer.call

    return handle_error unless importer.success?
    handle_success
  end

  private

  def handle_error
    error_msg = "Import of the file #{entry} failed with errors: \n #{result}"
    upload_error_file(entry, error_msg)
    mailer.send_import_feedback('Import CSV failed', error_content)
  end

  def handle_success
    File.delete(local_file)
    mailer.send_import_feedback("Successful Import. Import of the file #{entry} done.")
  end
end
