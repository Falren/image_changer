require 'rails_helper'

RSpec.describe SketchJob, type: :job do
  let(:image) { create(:image) }
  let(:options) { { "image_id" => image.id } }

  describe '#perform' do
    before do
      allow_any_instance_of(SketchJob).to receive(:broadcast_image_url)
      allow_any_instance_of(ImageDownloadService).to receive(:call).and_return(double('response', body: 'sketch_image_data'))
    end
    
    context 'file attached' do
      before { allow_any_instance_of(ImageDownloadService).to receive(:error).and_return(nil) }
      it 'downloads and attaches the sketch image to the image' do
        subject.perform(options)

        expect(image.file).to be_attached
        expect(image.file.content_type).to eq('image/jpg')
        expect(image.file.filename.to_s).to eq("image_sketch_#{image.trans_id}.jpg")
      end
    end

    context 'file not attached' do
      before { allow_any_instance_of(ImageDownloadService).to receive(:error).and_return('ERROR') }
   
      it 'does not update the image' do
        subject.perform(options)
      
        expect(image.file).not_to be_attached
      end
    end
  end
end
