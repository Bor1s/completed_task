# frozen_string_literal: true

namespace :mraba do
  desk 'Import CSV files from remote SFTP dir'
  task import: :environment do
    CsvExporter.transfer_and_import
  end
end
