module Api
  class ImagesController < ApplicationController
    include ExternalImageProcessing
    before_action :authorize_request
    
    def create
      return broadcast_image if Rails.env.development?
      return render json: { error: 'No file uploaded' }, status: :unprocessable_entity if params[:file].blank?
      
      credit_validation_service.call(current_user)
      return render json: { error: credit_validation_service.error }, status: :unprocessable_entity if credit_validation_service.error
      
      file = image_compress_service.call(params[:file])
      response = image_process_service.call(:cartoonize, file, 'cartoons')
      return render json: { error: image_process_service.error }, status: :unprocessable_entity if image_process_service.error
      return head :ok if @current_user.images.create(trans_id: response['data']['trans_id'])
      
      render json: { status: :unprocessable_entity }
    end

    private
    
    def broadcast_image
      ActionCable.server.broadcast("user_image_room:#{current_user.id}", ENV['TEST_IMAGE_URL'])
      head :ok
    end

    def image_compress_service
      @image_compress_service ||= ImageCompressService.new
    end
    
    def image_process_service
      @image_process_service ||= ImageProcessService.new
    end

    def credit_validation_service
      @credit_validation_service ||= CreditValidationService.new
    end

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
