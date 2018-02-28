# frozen_string_literal: true

class Lastschrift
  attr_reader :row, :validation_only, :dtaus
  private :row, :validation_only, :dtaus

  def initialize(row, dtaus, validation_only = false)
    @row = row
    @validation_only = validation_only
    @dtaus = dtaus
    @errors = []
  end

  def errors
    @errors.flatten
  end

  def success?
    errors.empty?
  end

  def add
    unless dtaus.valid_sender?(row['SENDER_KONTO'], row['SENDER_BLZ'])
      add_error("#{row['ACTIVITY_ID']}: BLZ/Konto not valid, csv fiile not written") && return
    end
    holder = Iconv.iconv('ascii//translit', 'utf-8', row['SENDER_NAME']).to_s.gsub(/[^\w^\s]/, '')
    dtaus.add_buchung(row['SENDER_KONTO'], row['SENDER_BLZ'], holder, BigDecimal(row['AMOUNT']).abs, import_subject(row))
  end

  private

  def add_error(message)
    @errors << message
  end

  def import_subject(row)
    subject = ''

    for id in (1..14).to_a
      subject += row["DESC#{id}"].to_s unless row["DESC#{id}"].blank?
    end

    subject
  end
end
