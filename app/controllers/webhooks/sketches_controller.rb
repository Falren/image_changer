module Webhooks 
  class SketchesController < BaseController
    def index
      return render json: { status: :unprocessable_entity } if image.nil?

      SketchJob.perform_async(image_id: image.id)
      render json: { status: :ok }
    end
  end
end
