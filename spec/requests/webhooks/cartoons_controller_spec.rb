require 'rails_helper'

RSpec.describe Webhooks::CartoonsController, type: :request do
  describe 'GET /webhooks/cartoons' do
    let(:image) { create(:image) }

    it 'returns a successful response and enqueues CartoonJob' do
      get '/webhooks/cartoons', params: { trans_id: image.trans_id }
      expect(response).to have_http_status(:ok)
    end

    it 'returns unprocessable_entity if image is nil' do
      get '/webhooks/cartoons'

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end

