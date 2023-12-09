require 'rails_helper'

RSpec.describe Webhooks::SketchesController, type: :request do
  describe 'GET /webhooks/sketches' do
  
    let!(:image) { create(:image) }
    it 'returns a successful response' do
      get '/webhooks/sketches', params: { trans_id: image.trans_id }
      expect(response).to have_http_status(:ok)
    end

    it 'returns unprocessable_entity if image is nil' do
      get '/webhooks/sketches'

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end

