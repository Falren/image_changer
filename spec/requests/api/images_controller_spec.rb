require 'rails_helper'

RSpec.describe Api::ImagesController do
  subject { response } 

  describe 'POST#create' do
    let!(:user) { create(:user) }
    let(:jwt_token) { JWT.encode({ sub: user.id }, Rails.application.credentials.devise[:jwt_secret_key]) }
    let(:file_path) { Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg') }
    let(:file) { fixture_file_upload(file_path) }
    let(:success_response) { {"code" => 200, "data" => {"trans_id" => "new_trans_id"}} }
    let(:headers) { { 'Authorization' => "Bearer #{jwt_token}" } }
    
    context 'with missing file' do
      let(:send_request) { post '/api/images', headers: headers }
      
      before { send_request }

      it { is_expected.to have_http_status(:unprocessable_entity) }
      it { expect(JSON.parse(response.body)['error']).to eq('No file uploaded') }
    end

    context 'with file' do
      let(:send_request) { post '/api/images', params: { file: file }, headers: headers }
      
      before do
        allow(ImageProcessService).to receive(:new).and_return(image_process_service)
        send_request
      end

      context 'when success' do
        let(:image_process_service) { instance_double(ImageProcessService, error: nil, call: success_response)}
        
        it { is_expected.to have_http_status(:ok) }
      end

      context 'when failure' do
        let(:image_process_service) { instance_double(ImageProcessService, error: 'Error', call: 'Error')}
        
        it { is_expected.to have_http_status(:unprocessable_entity) }
      end
    end

    context 'when authorization fails' do
      let(:send_request) { post '/api/images' }

      before { send_request }

      it { is_expected.to have_http_status(:unauthorized) }
    end
  end
end
