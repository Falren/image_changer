require 'rails_helper'

RSpec.describe SketchJob, type: :job do
  describe '#perform' do
    let(:image) { create(:image) }
    let(:options) { { "image_id" => image.id } }

    before do
      allow(subject).to receive(:download_image).and_return(double('response', body: 'sketch_image_data'))
      allow_any_instance_of(SketchJob).to receive(:broadcast_image_url)
    end

    it 'downloads and attaches the sketch image to the image' do
      subject.perform(options)

      expect(image.file).to be_attached
      expect(image.file.content_type).to eq('image/jpeg')
    end
  end
end
