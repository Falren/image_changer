
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
  
  describe 'POST#create' do 
    
    before { send_request }
    
    context 'when params are correct' do
      let(:send_request) { post sign_in_url, params: params }
      let(:decoded_token) { JWT.decode(response.headers['authorization'].split(' ').last, ENV["JWT_SECRET_KEY"], true) }

      it { expect(response).to have_http_status(200) }
      it { expect(response.headers['authorization']).to be_present }
      it { expect(decoded_token.first['sub']).to be_present }
    end

    context 'when login params are incorrect' do
      let(:send_request) { post sign_in_url }
      
      it { expect(response).to have_http_status(401) }
    end
  end
end