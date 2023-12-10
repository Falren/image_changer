require 'rails_helper'

RSpec.describe Webhooks::CartoonsController do
  let(:image) { create(:image) }
  subject { response }
  
  describe 'GET#index' do  
    
    before { send_request }
  
    context 'with  a successful response' do
      let(:send_request) { get '/webhooks/cartoons', params: { trans_id: image.trans_id } }
      
      it { is_expected.to have_http_status(:ok) }
    end

    context 'with an unsucssesful reponse' do
      let(:send_request) { get '/webhooks/cartoons' }

      it { is_expected.to have_http_status(:unprocessable_entity) } 
    end
  end
end

