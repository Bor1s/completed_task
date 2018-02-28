# frozen_string_literal: true

RSpec.describe ImportFile, type: :service do
  subject { described_class }

  describe 'constants' do
    it 'has SOURCE_PATH' do
      expect(subject::SOURCE_PATH).to eq Rails.root.join('private', 'upload').to_s
    end
  end

  describe '#call' do
    let(:file_path) { Rails.root.join('spec', 'fixtures', 'data.csv') }
    let(:private_csv_dir) { "#{described_class::SOURCE_PATH}/csv" }
    let(:private_tmp_mraba_dir) { "#{described_class::SOURCE_PATH}/csv/tmp_mraba" }
    subject { described_class.new(file_path) }

    it 'creates private dirs' do
      subject.call

      expect(File.directory?(private_csv_dir)).to be true
      expect(File.directory?(private_tmp_mraba_dir)).to be true
    end

    context 'when data is invalid' do
      let(:total_invalid_rows_in_test_csv) { 5 }

      context 'and UMASTZ_KEY is not allowed' do
        it 'returns error for each invalid row' do
          subject.call

          expect(subject.success?).to be false
          expect(subject.errors.count).to eq total_invalid_rows_in_test_csv
          expect(subject.errors.last).to eq '01: UMSATZ_KEY 06 is not allowed'
        end
      end

      context 'and transaction type is not allowed' do
        let(:file_path) { Rails.root.join('spec', 'fixtures', 'data_transaction_invalid.csv') }

        it 'returns error for each invalid row' do
          subject.call

          expect(subject.success?).to be false
          expect(subject.errors.count).to eq total_invalid_rows_in_test_csv
          expect(subject.errors.last).to eq '01: Transaction type not found'
        end
      end
    end

    context 'when data is valid for' do
      let(:total_valid_rows_in_test_csv) { 5 }

      context 'account transfer' do
        let(:mraba) { instance_double(Mraba::Transaction) }
        let(:file_path) { Rails.root.join('spec', 'fixtures', 'data_valid.csv') }
        let(:account) { spy('account', present?: true) }
        subject { described_class.new(file_path, mraba) }

        before do
          allow(Account).to receive(:find_by_account_no).and_return(account)
          allow(mraba).to receive(:add_datei)
        end

        it 'returns success' do
          subject.call

          expect(subject.success?).to be true
          expect(subject.imported_rows.count).to eq total_valid_rows_in_test_csv
        end

        it 'sets date to dtaus' do
          expect(mraba).to receive(:add_datei).once

          subject.call
        end
      end

      context 'bank transfer' do
        # TODO: Here should go similar tests for BankTransfer
      end

      context 'lastschrift' do
        # TODO: Here should go similar tests for Lastschrift
      end
    end
  end
end
