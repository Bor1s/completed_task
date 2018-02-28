# frozen_string_literal: true

# NOTE: I decided to keep the same name for
# CsvExporter and #transfer_and_import metod
# for bakwards compatibility
# but personally I would rename it to
# something more suitable, like ImportTransactionData.call
class CsvExporter
  class << self
    def transfer_and_import
      metadata = GetFilesMetadata.new(MrabaSftp).call
      metadata.each do |entry|
        file_path = DownloadFile.new(MrabaSftp, entry).call
        importer = ImportFile.new(file_path)
        importer.call

        unless importer.success?
          handle_error(entry, importer.errors.join("\n"))
          next
        end

        handle_success(entry, file_path)
      end
    end
  end

  private

  class << self
    def handle_error(entry, message, send_mail = true)
      error_msg = "Import of the file #{entry} failed with errors: \n #{message}"
      UploadErrorFile.new(MrabaSftp, entry, error_msg).call
      ApplicationMailer.send_import_feedback('Import CSV failed', error_msg) if send_mail
    end

    def handle_success(entry, file_path, send_mail = true)
      File.delete(file_path)
      ApplicationMailer.send_import_feedback("Successful Import. Import of the file #{entry} done.") if send_mail
    end
  end
end
