module Webhooks 
  class CartoonsController < BaseController
    def index
      return render json: { status: :unprocessable_entity } if image.nil?
      
      CartoonJob.perform_async(image_id: image.id)
      render json: { status: :ok } 
    end
  end
end
