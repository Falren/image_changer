module Webhooks 
  class SketchesController < BaseController
    def index
      return head :unprocessable_entity if image.nil?

      SketchJob.perform_async(image_id: image.id)
      head :ok
    end
  end
end
