module Api
  class ImagesController < ApplicationController
    before_action :authorize_request
    
    def create
      return render json: { error: 'No file uploaded' }, status: :unprocessable_entity unless params[:file].present?

      process_image(:cartoonize, params[:file], 'cartoons') 
      render json: { status: :ok }
    end

    def authorize_request
      header = request.headers['Authorization']
      header = header.split(' ').last if header
      begin
        @decoded = JWT.decode(
          request.headers['Authorization'].split(' ')[1],
          Rails.application.credentials.devise[:jwt_secret_key]
        ).first
        @current_user = User.find(@decoded[:user_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { errors: e.message }, status: :unauthorized
      end
    end
  end
end
