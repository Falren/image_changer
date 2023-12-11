require 'rails_helper'

RSpec.describe SketchJob, type: :job do
  let(:image) { create(:image) }
  let(:options) { { "image_id" => image.id } }

  describe '#perform' do
    before do
      allow_any_instance_of(SketchJob).to receive(:broadcast_image_url)
      allow_any_instance_of(ImageDownloadService).to receive(:call).and_return(double('response', body: 'sketch_image_data'))
      allow_any_instance_of(CreditValidationService).to receive(:error).and_return(nil) 
    end
    
    context 'when file attached' do
      before do 
        allow_any_instance_of(ImageDownloadService).to receive(:error).and_return(nil) 
        subject.perform(options)
      end

      it { expect(image.file).to be_attached }
      it { expect(image.file.content_type).to eq('image/jpg') }
      it { expect(image.file.filename.to_s).to eq("image_sketch_#{image.trans_id}.jpg") }
      it { expect { subject.perform(options) }.to change { image.user_subscription.reload.credit }.by(-1) }
    end

    context 'when file not attached' do
      before do 
        allow_any_instance_of(ImageDownloadService).to receive(:error).and_return('ERROR') 
        subject.perform(options)
      end

      it { expect(image.file).not_to be_attached }
      it { expect { subject.perform(options) }.to change { image.user_subscription.reload.credit }.by(0) }
    end


    context 'when insufficient funds' do
      before do 
        allow_any_instance_of(CreditValidationService).to receive(:error).and_return('ERROR') 
        subject.perform(options)
      end
      
      it { expect { subject.perform(options) }.to change { image.user_subscription.reload.credit }.by(0) }
    end
  end
end
