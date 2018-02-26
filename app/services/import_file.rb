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

  #   def self.import(file, validation_only = false)
  #     begin
  #       result = import_file(file, validation_only)
  #     rescue => e
  #       result = { :errors => [e.to_s], :success => ['data lost'] }
  #     end
  #
  #     if result[:errors].blank?
  #       result = "Success"
  #     else
  #       result = "Imported: #{result[:success].join(', ')} Errors: #{result[:errors].join('; ')}"
  #     end
  #
  #     Rails.logger.info "CsvExporter#import time: #{Time.now.to_formatted_s(:db)} Imported #{file}: #{result}"
  #
  #     result
  #   end
end
