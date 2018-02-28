# frozen_string_literal: true

RSpec.describe FindStrategy, type: :service do
  subject { described_class }

  describe 'constants' do
    it 'has STRATEGIES' do
      expect(subject::STRATEGIES.keys).to include('account_transfer', 'bank_transfer', 'lastschrift')
    end
  end

  describe '#call' do
    let(:row) { double }
    let(:dtaus) { double }

    it 'initializes AccountTransfer strategy' do
      result = described_class.new('account_transfer', row, dtaus).call
      expect(result).to be_a(AccountTransfer)
    end

    it 'initializes BankTransfer strategy' do
      result = described_class.new('bank_transfer', row, dtaus).call
      expect(result).to be_a(BankTransfer)
    end

    it 'initializes Lastschrift strategy' do
      result = described_class.new('lastschrift', row, dtaus).call
      expect(result).to be_a(Lastschrift)
    end

    it 'initializes ErrorStrategy' do
      result = described_class.new('unknown', row, dtaus).call
      expect(result).to be_a(ErrorStrategy)
    end
  end
end
