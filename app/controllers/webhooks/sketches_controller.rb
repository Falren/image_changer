module Webhooks 
  class SketchesController < BaseController
    def index
      return render json: { status: :unprocessable_entity } if image.nil?

      response = download_image
      file = StringIO.new(response.body)
      image.file.attach(
        io: file, 
        filename: "image_sketch_#{image.trans_id}.jpg", 
        content_type: 'image/jpg'
      )
      url_for(image.file)
      render json: { status: :ok }
    end
  end
end
