require 'rails_helper'

RSpec.describe ImageCompressService, type: :service do
  let(:file_path) { Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg') }
  let(:file) { File.open(file_path) }
  let!(:file_size) { file.size }
  let(:service) { described_class.new }

  subject { service.call(file) }

  describe '#call' do
    context 'when the file and reduces size' do
      
      before { stub_const('ImageCompressService::MAX_FILE_SIZE', 100.kilobytes) }
      
      it { expect(subject.size).to be <= ImageCompressService::MAX_FILE_SIZE }
    end
  end
end
