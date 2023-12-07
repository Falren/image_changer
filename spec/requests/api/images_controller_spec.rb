require 'rails_helper'

RSpec.describe Api::ImagesController, type: :request do
  describe 'POST #create' do
    let!(:user) { create(:user) }
    let(:jwt_token) { JWT.encode({ sub: user.id }, Rails.application.credentials.devise[:jwt_secret_key]) }
    let(:headers) { { 'Authorization' => "Bearer #{jwt_token}" } }
    let(:file_path) { Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg') }
    let(:file) { fixture_file_upload(file_path) }

    context 'with missing file' do
      it 'returns unprocessable_entity status and an error message' do
        post '/api/images', headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('No file uploaded')
      end
    end

    context 'with file' do
      it 'creates an image and returns a successful response' do
        allow_any_instance_of(Api::ImagesController).to receive(:process_image).and_return('mocked_trans_id')

        post '/api/images', params: { file: file }, headers: headers

        expect(response).to have_http_status(:ok)
        expect(user.images.count).to eq(1)
        expect(user.images.first.trans_id).to eq('mocked_trans_id')
      end
    end

    context 'when authorization fails' do
      it 'returns unauthorized status and an error message' do
        post '/api/images'

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['errors']).to be_present
      end
    end
  end
end
