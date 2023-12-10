require 'rails_helper'

RSpec.describe ImageProcessService do
  describe '#call' do
    let(:file_path) { Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg') }
    let(:file) { File.open(file_path) }
    let(:type) { 'type' }
    let(:endpoint) { 'endpoint' }
    let(:result_double) { double(body: result.to_json) }
    let(:service) { described_class.new }
    
    subject { service.call(type, file, endpoint) }

    context 'returns parsed response on success' do
      let(:result) { { 'code' => 200, 'data' => { 'result' => 'processed' } } }
      
      before do 
        allow_any_instance_of(ImageProcessService).to receive(:upload_image).and_return(result_double)
        allow_any_instance_of(ImageProcessService).to receive(:transform_image).and_return(result.to_json)
      end

      it { is_expected.to eq(result) }
      it { expect { subject }.not_to change(service, :error) }
    end

    context 'sets an error message on failure' do
      let(:result) { { 'code' => 500,  'msg' => 'Error uploading image' } }
      
      before { allow_any_instance_of(ImageProcessService).to receive(:upload_image).and_return(result_double)  }

      it { is_expected.to eq(result['msg']) }
      it { expect { subject }.to change(service, :error).from(nil).to(result['msg']) }
    end
  end
end
