module Api
  class ImagesController < ApplicationController
    include ExternalImageProcessing
    before_action :authorize_request
    
    def create
      return render json: { error: 'No file uploaded' }, status: :unprocessable_entity if params[:file].blank?
      return render json: { error: credit_validation_service.error } if credit_validation_service.call(current_user)
      
      file = ImageCompressService.new.call(params[:file])
      response = image_process_service.call(:cartoonize, file, 'cartoons')
      return render json: { error: image_process_service.error }, status: :unprocessable_entity if image_process_service.error
      return head :ok if @current_user.images.create(trans_id: response['data']['trans_id'])
      
      render json: { status: :unprocessable_entity }
    end

    private

    def image_process_service
      image_process_service ||= ImageProcessService.new
    end

    def credit_validation_service
      credit_validation_service ||= CreditValidationService.new
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
