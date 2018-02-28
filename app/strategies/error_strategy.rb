# frozen_string_literal: true

class ErrorStrategy
  attr_reader :row, :validation_only
  private :row, :validation_only

  def initialize(row, dtaus, validation_only = false)
    @errors = []
    @row = row
    @dtaus = dtaus
    @validation_only = validation_only
  end

  def add
    add_error("#{row['ACTIVITY_ID']}: Transaction type not found")
  end

  def errors
    @errors.flatten
  end

  def success?
    errors.empty?
  end

  private

  def add_error(message)
    @errors << message
  end
end
