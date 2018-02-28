# frozen_string_literal: true

class AccountTransfer
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
    # TODO: should be properly refactored.
    sender = get_sender(row)
    return unless sender

    if row['DEPOT_ACTIVITY_ID'].blank?
      account_transfer = sender.credit_account_transfers.build(amount: row['AMOUNT'].to_f, subject: import_subject(row), receiver_multi: row['RECEIVER_KONTO'])
      account_transfer.date = row['ENTRY_DATE'].to_date
      account_transfer.skip_mobile_tan = true
    else
      account_transfer = sender.credit_account_transfers.find_by_id(row['DEPOT_ACTIVITY_ID'])
      if account_transfer.nil?
        add_error("#{row['ACTIVITY_ID']}: AccountTransfer not found") && return
      elsif account_transfer.state != 'pending'
        add_error("#{row['ACTIVITY_ID']}: AccountTransfer state expected 'pending' but was '#{account_transfer.state}'") && return
      else
        account_transfer.subject = import_subject(row)
      end
    end
    if account_transfer && !account_transfer.valid?
      add_error("#{row['ACTIVITY_ID']}: AccountTransfer validation error(s): #{account_transfer.errors.full_messages.join('; ')}")
    elsif !validation_only
      row['DEPOT_ACTIVITY_ID'].blank? ? account_transfer.save! : account_transfer.complete_transfer!
    end
  end

  private

  def get_sender(row)
    sender = Account.find_by_account_no(row['SENDER_KONTO'])
    add_error("#{row['ACTIVITY_ID']}: Account #{row['SENDER_KONTO']} not found") unless sender.present?
    sender
  end

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
