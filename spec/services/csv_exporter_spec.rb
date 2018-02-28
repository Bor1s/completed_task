# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvExporter, type: :service do
  describe '.transfer_and_import' do
    let(:file_name) { 'data_valid.csv' }
    let(:file_path) { Rails.root.join('spec', 'fixtures', file_name) }

    before do
      allow(described_class).to receive(:handle_success)
      allow(described_class).to receive(:handle_error)
      allow_any_instance_of(GetFilesMetadata).to receive(:call).and_return([file_name])
      allow_any_instance_of(DownloadFile).to receive(:call).and_return(file_path)
      allow_any_instance_of(ImportFile).to receive(:call)
    end

    it 'calls GetFilesMetadata#call' do
      expect_any_instance_of(GetFilesMetadata).to receive(:call).once

      described_class.transfer_and_import
    end

    it 'calls DownloadFile#call for each metadata entry' do
      expect_any_instance_of(DownloadFile).to receive(:call).once

      described_class.transfer_and_import
    end

    it 'calls ImportFile#call for each metadata entry' do
      expect_any_instance_of(ImportFile).to receive(:call).once

      described_class.transfer_and_import
    end
  end

  # TODO: more test should be written
end
