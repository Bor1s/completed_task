# frozen_string_literal: true

RSpec.describe GetFilesMetadata, type: :service do
  subject { described_class }

  describe 'constants' do
    it 'has REMOTE_CSV_DIR' do
      expect(subject::REMOTE_CSV_DIR).to eq '/data/files/csv'
    end

    it 'has CSV' do
      expect(subject::CSV_EXT).to eq '.csv'
    end
  end

  describe '#call' do
    let(:sftp) { MrabaSftp }
    let(:private_data_dir) { "#{Rails.root}/private/data" }
    let(:private_data_download_dir) { "#{Rails.root}/private/data/download" }
    let(:entry_csv) { double('mraba.csv', name: 'mraba.csv') }
    let(:entry_csv_start) { double('mraba.csv.start', name: 'mraba.csv.start') }
    let(:entries) { [entry_csv, entry_csv_start] }
    let(:dir_object) { double }
    let(:sftp_object) { double(OpenStruct, dir: dir_object) }
    subject { described_class.new(sftp) }

    before do
      allow(dir_object).to receive(:entries).with('/data/files/csv').and_return(entries)
      allow(Net::SFTP).to receive(:start) do |&block|
        block.call(sftp_object)
      end
    end

    it 'creates private dirs' do
      subject.call

      expect(File.directory?(private_data_dir)).to be true
      expect(File.directory?(private_data_download_dir)).to be true
    end

    it 'returns csv files from the remote dir' do
      result = subject.call

      expect(result.count).to eq 1
      expect(result.first.name).to eq 'mraba.csv'
    end
  end
end
