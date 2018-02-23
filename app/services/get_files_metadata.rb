# frozen_string_literal: true

class GetFilesMetadata
  REMOTE_CSV_DIR = '/data/files/csv'
  CSV = '.csv'

  attr_reader :sftp
  private :sftp

  def initialize(sftp)
    @sftp = sftp
  end

  def call
    create_private_dirs
    start_sftp_import
  end

  private

  def create_private_dirs
    FileUtils.mkdir_p "#{Rails.root}/private/data"
    FileUtils.mkdir_p "#{Rails.root}/private/data/download"
  end

  def start_sftp_import
    # TODO: User, endpoint and keys should be validated.
    Net::SFTP.start(sftp) do |sftp|
      # sftp_entries = sftp.dir.entries(REMOTE_CSV_DIR).map(&:name).sort
      sftp.dir.entries(REMOTE_CSV_DIR).select do |entry|
        ends_with_csv?(entry.name) && contain_start_file?(sftp_entries, entry.name)
      end
    end
  end

  def ends_with_csv?(name)
    name[-4, 4] = CSV
  end

  # NOTE: Slow place: O(N^2).
  # Needs to be replaced with hash containing:
  # { entry_name: ['name.csv', 'name.csv.start']}
  def contain_start_file?(_entries, name)
    entries('/data/files/csv').include?(name + '.start')
  end
end
