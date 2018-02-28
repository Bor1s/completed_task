# frozen_string_literal: true

RSpec.describe AccountTransfer, type: :strategy do
  subject { described_class }

  describe '#add' do
    let(:row) { { 'ENTRY_DATE' => Time.current } }
    let(:dtaus) { double }
    let(:account) { spy('account', present?: true) }
    let(:account_transfer) { spy(CreditAccountTransfer, state: 'pending') }
    subject { described_class.new(row, dtaus) }

    before do
      allow(Account).to receive(:find_by_account_no).and_return(account)
    end

    context 'when success' do
      context 'when DEPOT_ACTIVITY_ID is nil' do
        before do
          allow(account).to receive_message_chain(:credit_account_transfers, :build).and_return(account_transfer)
        end

        it 'call saves account_transfer' do
          expect(account_transfer).to receive(:save!)
          subject.add
        end
      end

      context 'when DEPOT_ACTIVITY_ID present' do
        let(:row) { { 'DEPOT_ACTIVITY_ID' => 1, 'ENTRY_DATE' => Time.current } }

        before do
          allow(account).to receive_message_chain(:credit_account_transfers, :find_by_id).and_return(account_transfer)
        end

        it 'calls #complete_transfer!' do
          expect(account_transfer).to receive(:complete_transfer!)

          subject.add
        end
      end
    end

    context 'when failure' do
      let(:row) { { 'DEPOT_ACTIVITY_ID' => 1, 'ENTRY_DATE' => Time.current } }
      let(:account_transfer) { spy(CreditAccountTransfer, state: 'other') }

      it 'returns error' do
        subject.add

        expect(subject.errors.count).to eq 1
        expect(subject.errors.first).to include("AccountTransfer state expected 'pending' but was")
      end
    end

    # TODO: more test should be written
  end
end
