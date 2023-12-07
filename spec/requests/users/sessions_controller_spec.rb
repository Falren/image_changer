
require 'rails_helper'

RSpec.describe Users::SessionsController, type: :request do
  let!(:user) { create(:user) }
  let(:sign_in_url) { '/users/sign_in' }
  let(:sign_out_url) { '/users/sign_out' }
  let(:params) do
    { user: {
      email: user.email,
      password: user.password
    }}
  end

  describe 'POST /users/sing_in' do 
    context 'when params are correct' do
      before do
        post sign_in_url, params: params
      end

      it 'returns 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns JTW token in authorization header' do
        expect(response.headers['authorization']).to be_present
      end

      it 'returns valid JWT token' do
        decoded_token = JWT.decode(response.headers['authorization'].split(' ').last, Rails.application.credentials.devise[:jwt_secret_key], true)
        expect(decoded_token.first['sub']).to be_present
      end
    end

    context 'when login params are incorrect' do
      before { post sign_in_url }
      
      it 'returns unathorized status' do
        expect(response.status).to eq 401
      end
    end
  end
end