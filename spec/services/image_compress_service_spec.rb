
require 'rails_helper'

RSpec.describe FileCompressorService, type: :service do
  subject(:file_compressor) { described_class.new }

  let(:original_file) { instance_double('ImageProcessing::Vips::Image') }

  describe '#call' do
    context 'when compressing a file' do
      before do
        allow(ImageProcessing::Vips).to receive(:convert).and_return(instance_double('ImageProcessing::Vips::Processor', call: original_file))
        allow(ImageProcessing::Vips).to receive(:saver).and_return(instance_double('ImageProcessing::Vips::Processor', call: original_file))
      end

      it 'compresses the file if size is above the threshold' do
        allow(original_file).to receive(:size).and_return(15.megabytes)
        allow(original_file).to receive(:quality)

        expect(file_compressor.call(original_file)).to eq(original_file)
      end

      it 'does not compress if file size is already below the threshold' do
        allow(original_file).to receive(:size).and_return(5.megabytes)

        expect(file_compressor.call(original_file)).to eq(original_file)
      end
    end

    context 'when ImageProcessing::Vips.convert fails' do
      before do
        allow(ImageProcessing::Vips).to receive(:convert).and_raise(StandardError, 'Conversion failed')
      end

      it 'raises an error' do
        expect { file_compressor.call(original_file) }.to raise_error(StandardError, 'Conversion failed')
      end
    end
  end
end
