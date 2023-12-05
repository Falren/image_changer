module Webhooks 
  class CartoonsController < BaseController
    def index
      return render json: { status: :unprocessable_entity } if image.nil?

      response = download_image
      @tmp_image = Tempfile.new(["temp_image_#{image.trans_id}",'.jpg'])
      @tmp_image.set_encoding('ASCII-8BIT')
      @tmp_image.write response.body
      @tmp_image.rewind
      trans_id = process_image(:sketch, @tmp_image, 'sketches')
      return render json: { status: :ok } if image_user.images.create(trans_id: trans_id)
      
      render json: { status: :unprocessable_entity }
    end
  end
end
