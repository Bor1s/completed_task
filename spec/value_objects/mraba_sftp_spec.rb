# frozen_string_literal: true

RSpec.describe MrabaSftp, type: :value_object do
  subject { described_class }

  describe '.endpoint' do
    it 'returns sftp endpoint' do
      expect(subject.endpoint).to eq 'test_endpoint'
    end
  end

  describe '.user' do
    it 'returns sftp user' do
      expect(subject.user).to eq 'test_username'
    end
  end

  describe '.keys' do
    it 'returns keys' do
      expect(subject.keys).to eq ['test_secret']
    end
  end
end
