module Webhooks 
  class CartoonsController < BaseController
    def index
      return head :unprocessable_entity if image.nil?

      CartoonJob.perform_async(image_id: image.id)
      head :ok
    end
  end
end
