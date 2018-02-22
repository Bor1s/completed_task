# frozen_string_literal: true

class ImportFile
  attr_reader :success
  private :success

  def initialize(_file)
    @success = true
  end

  def call
    # TODO: continue here debugging #import method in original CsvExporter
  end

  def success?
    success == 'Success'
  end
end
