# frozen_string_literal: true

class BankTransfer
  attr_reader :row, :validation_only
  private :row, :validation_only

  def initialize(row, dtaus, validation_only = false)
    @row = row
    @dtaus = dtaus
    @validation_only = validation_only
    @errors = []
  end

  def success?
    errors.empty?
  end

  def errors
    @errors.flatten
  end

  def add
    sender = get_sender(row)
    return unless sender

    bank_transfer = sender.build_transfer(
      amount: row['AMOUNT'].to_f,
      subject: import_subject(row),
      rec_holder: row['RECEIVER_NAME'],
      rec_account_number: row['RECEIVER_KONTO'],
      rec_bank_code: row['RECEIVER_BLZ']
    )

    if !bank_transfer.valid?
      add_error("#{row['ACTIVITY_ID']}: BankTransfer validation error(s): #{bank_transfer.errors.full_messages.join('; ')}")
    elsif !validation_only
      bank_transfer.save!
    end
  end

  private

  def get_sender(row)
    sender = Account.find_by_account_no(row['SENDER_KONTO'])
    add_error("#{row['ACTIVITY_ID']}: Account #{row['SENDER_KONTO']} not found") if sender.blank?
    sender
  end

  def add_error(message)
    @errors << message
  end
end
