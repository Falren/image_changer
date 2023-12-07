require 'rails_helper'

RSpec.describe CartoonJob, type: :job do
  describe 'performing the CartoonJob' do
    let(:image) { create(:image) }
    let(:options) { { "image_id" => image.id } }
    let(:tmp_image) { Tempfile.new(["temp_image_#{image.trans_id}", '.jpg']) }

    before do
      allow(subject).to receive(:download_and_tempfile).and_return(tmp_image)
      allow(subject).to receive(:process_temp_image).and_return("new_trans_id")
    end

    it 'updates the image trans_id' do
      subject.perform(options)

      expect(image.reload.trans_id).to eq("new_trans_id")
    end

    context 'failed to update' do
      before { allow(image).to receive(:update)}
      
      context 'when image is not found' do
        before { allow(Image).to receive(:find_by).and_return(nil) }

        it 'does not update the image' do
          subject.perform(options)

          expect(image).to_not have_received(:update).with(trans_id: "new_trans_id")
        end
      end

      context 'when download_and_tempfile fails' do
        before { allow(subject).to receive(:download_and_tempfile).and_return(nil) }

        it 'does not update the image' do
          subject.perform(options)

          expect(image).to_not have_received(:update).with(trans_id: "new_trans_id")
        end
      end

      context 'when process_temp_image returns nil' do
        before { allow(subject).to receive(:process_temp_image).and_return(nil) }

        it 'does not update the image' do
          subject.perform(options)

          expect(image).to_not have_received(:update).with(trans_id: "new_trans_id")
        end
      end
    end
  end
end
