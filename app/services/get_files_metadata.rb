# frozen_string_literal: true

class GetFilesMetadata
  REMOTE_CSV_DIR = '/data/files/csv'
  CSV_EXT = '.csv'

  attr_reader :sftp, :result
  private :sftp, :result

  def initialize(sftp)
    @sftp = sftp
    @result = []
  end

  def call
    create_private_dirs
    start_sftp_import
    result
  end

  private

  def create_private_dirs
    FileUtils.mkdir_p "#{Rails.root}/private/data"
    FileUtils.mkdir_p "#{Rails.root}/private/data/download"
  end

  def start_sftp_import
    Net::SFTP.start(sftp.endpoint, sftp.user, keys: sftp.keys) do |sftp|
      @result = sftp.dir.entries(REMOTE_CSV_DIR).select do |entry|
        ends_with_csv?(entry.name) && contain_start_file?(sftp.dir.entries(REMOTE_CSV_DIR), entry.name)
      end
    end
  end

  def ends_with_csv?(name)
    name[-4, 4] == CSV_EXT
  end

  # NOTE: Slow place: O(N^2).
  # Needs to be replaced with hash containing:
  # { entry_name: ['name.csv', 'name.csv.start']}
  def contain_start_file?(entries, name)
    entries.find { |entry| entry.name == "#{name}.start" }.present?
  end
end
