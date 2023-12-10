module Api
  class ImagesController < ApplicationController
    include ExternalImageProcessing
    before_action :authorize_request
    
    def create
      return render json: { error: 'No file uploaded' }, status: :unprocessable_entity if params[:file].blank?

      file = ImageCompressService.new.call(params[:file])
      image_process = ImageProcessService.new
      response = image_process.call(:cartoonize, file, 'cartoons')
      return render json: { error: image_process.error }, status: :unprocessable_entity if image_process.error
      return head :ok if @current_user.images.create(trans_id: response['data']['trans_id'])
      
      render json: { status: :unprocessable_entity }
    end

    private

    def authorize_request
      header = request.headers['Authorization']
      header = header.split(' ').last if header
      begin
        @decoded = JWT.decode(header,
                             Rails.application.credentials.devise[:jwt_secret_key]).first
        user_id = @decoded['sub']
        @current_user = User.find(user_id)
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { errors: e.message }, status: :unauthorized
      end
    end
  end
end
