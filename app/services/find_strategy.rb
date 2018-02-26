# frozen_string_literal: true

class FindStrategy
  STRATEGIES = {
    'account_transfer' => AccountTransfer,
    'bank_transfer' => BankTransfer,
    'lastschrift' => Lastschrift
  }.freeze

  attr_reader :row, :type, :dtaus
  private :row, :type, :dtaus

  def initialize(type, row, dtaus)
    @type = type
    @row = row
    @dtaus = dtaus
  end

  def call
    (STRATEGIES[type] || ErrorStrategy).new(row, dtaus)
  end
end
