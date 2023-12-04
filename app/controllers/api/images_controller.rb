module Api
  class ImagesController < ApplicationController
    before_action :authenticate_user!
    
    def create
      return render json: { error: 'No file uploaded' }, status: :unprocessable_entity unless params[:file].present?

      process_image(:cartoonize, params[:file], 'cartoons') 
      render json: { status: :ok }
    end
  end

  
  def get_user_from_token
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1],
                             Rails.application.credentials.devise[:jwt_secret_key]).first
    user_id = jwt_payload['sub']
    User.find(user_id.to_s)
  end
end
