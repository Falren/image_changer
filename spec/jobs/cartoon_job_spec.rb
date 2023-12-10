require 'rails_helper'

RSpec.describe CartoonJob, type: :job do
  describe 'performing the CartoonJob' do
    let(:image) { create(:image) }
    let(:options) { { "image_id" => image.id } }
    let(:tmp_image) { Tempfile.new(["temp_image_#{image.trans_id}", '.jpg']) }
    let(:success_response) {{"code" => 200, "data" => {"trans_id" => "new_trans_id"}}}
    let(:failure_response) {{"code" => 400}}
    
    before do
      allow(subject).to receive(:process_temp_image).and_return(tmp_image)
      allow_any_instance_of(ImageDownloadService).to receive_messages(:call => nil, :error => nil)
      allow_any_instance_of(ImageProcessService).to receive_messages(:call => success_response, :error => nil)
      subject.perform(options)
    end


    context 'updates the image trans_id' do
      it { expect(image.reload.trans_id).to eq("new_trans_id") }
    end

    context 'failed to update' do
      
      before { allow(image).to receive(:update) } 
      
      context 'when image is not found' do
       
        before  { allow_any_instance_of(ImageDownloadService).to receive(:error).and_return('ERROR') }

        it { expect(image).to_not have_received(:update).with(trans_id: "new_trans_id") }
      end

      context 'when process_temp_image returns nil' do
        
        before { allow(subject).to receive(:process_temp_image).and_return(failure_response) }

        it { expect(image).to_not have_received(:update).with(trans_id: "new_trans_id") }
      end
    end
  end
end
