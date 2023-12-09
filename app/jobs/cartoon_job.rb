class CartoonJob < ApplicationJob
  def perform(options)
    image = Image.find_by(id: options["image_id"])
    image_service = ImageDownloadService.new
    parsed_response = image_service.call(image)
    return handle_error(image_service.error) if image_service.error
    
    response = process_temp_image(image.trans_id, parsed_response)
    return handle_error(response['msg']) if response['code'] != 200

    image.update(trans_id: response['data']['trans_id'])
  end

  private

  def find_image(image_id)
    Image.find_by(id: image_id)
  end

  def process_temp_image(trans_id, response)
    tmp_image = Tempfile.new(["temp_image_#{trans_id}",'.jpg'])
    tmp_image.set_encoding('ASCII-8BIT')
    tmp_image.write response.body
    tmp_image.rewind
    process_image(:sketch, tmp_image, 'sketches')
  end
end
