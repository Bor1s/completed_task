# frozen_string_literal: true

class ImportFile
  attr_reader :success, :file_path
  private :success, :file_path

  def initialize(file_path)
    @file_path = file_path
    @success = true
  end

  def call
    # TODO: continue here debugging #import method in original CsvExporter
  end

  def success?
    success == 'Success'
  end

  def error
    # TODO: here goes error message if any
  end
end
