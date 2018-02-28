# frozen_string_literal: true

require 'csv'

class ImportFile
  SOURCE_PATH = "#{Rails.root}/private/upload"

  attr_reader :file_path, :path_and_name, :activity_ids, :dtaus, :imported_rows
  private :file_path, :path_and_name, :activity_ids, :dtaus, :imported_rows

  def initialize(file_path, dtaus = Mraba::Transaction)
    @file_path = file_path
    @errors = []
    @imported_rows = []
    @path_and_name = "#{SOURCE_PATH}/csv/tmp_mraba/DTAUS#{Time.current.strftime('%Y%m%d_%H%M%S')}"
    @dtaus = dtaus.define_dtaus('RS', 8_888_888_888, 99_999_999, 'Credit collection')
  end

  def success?
    errors.empty?
  end

  def errors
    @errors.flatten
  end

  def call
    create_private_dirs
    process_rows(read_csv)
    dtaus.add_datei("#{path_and_name}_201_mraba.csv") if success?
  rescue StandardError => e
    add_error("#{e.message}\n#{e.backtrace}")
  end

  private

  def read_csv
    CSV.read(file_path, col_sep: ';', headers: true, skip_blanks: true).map do |row|
      data = row.to_hash
      data if data['ACTIVITY_ID'].present?
    end.compact
  end

  def process_rows(rows)
    rows.each do |row|
      if row_valid?(row)
        strategy = FindStrategy.new(transaction_type(row), row, dtaus).call
        strategy.add
        strategy.success? ? add_imported_rows(row['ACTIVITY_ID']) : add_error(strategy.errors)
      else
        add_error("#{row['ACTIVITY_ID']}: UMSATZ_KEY #{row['UMSATZ_KEY']} is not allowed")
      end
    end
  end

  def create_private_dirs
    FileUtils.mkdir_p "#{SOURCE_PATH}/csv"
    FileUtils.mkdir_p "#{SOURCE_PATH}/csv/tmp_mraba"
  end

  def row_valid?(row)
    %(10 16).include?(row['UMSATZ_KEY'])
  end

  def add_imported_rows(activity_id)
    @imported_rows << activity_id
  end

  def add_error(message)
    @errors << message
  end

  def transaction_type(row)
    if (row['SENDER_BLZ'] == '00000000') && (row['RECEIVER_BLZ'] == '00000000')
      'account_transfer'
    elsif (row['SENDER_BLZ'] == '00000000') && (row['UMSATZ_KEY'] == '10')
      'bank_transfer'
    elsif (row['RECEIVER_BLZ'] == '70022200') && ['16'].include?(row['UMSATZ_KEY'])
      'lastschrift'
    end
  end
end
