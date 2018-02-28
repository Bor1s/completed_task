# frozen_string_literal: true

RSpec.describe DownloadFile, type: :service do
  subject { described_class }

  describe 'constants' do
    it 'has START_EXT' do
      expect(subject::START_EXT).to eq '.start'
    end
  end

  describe '#call' do
    let(:sftp) { MrabaSftp }
    let(:sftp_object) { double }
    let(:entry) { double }
    subject { described_class.new(sftp, entry) }

    before do
      allow(sftp_object).to receive(:download!)
      allow(sftp_object).to receive(:remove!)
      allow(Net::SFTP).to receive(:start) do |&block|
        block.call(sftp_object)
      end
    end

    it 'downloads file from remote dir and saves locally' do
      expect(sftp_object).to receive(:download!)
      expect(sftp_object).to receive(:remove!)

      subject.call
    end
  end
end
