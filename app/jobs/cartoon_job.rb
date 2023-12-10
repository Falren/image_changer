class CartoonJob < ApplicationJob
  def perform(options)
    image = Image.find_by(id: options["image_id"])
    image_download = ImageDownloadService.new
    parsed_response = image_download.call(image)
    return handle_error(image_download.error) if image_download.error
    
    image_process = ImageProcessService.new
    tmp_file = process_temp_image(image.trans_id, parsed_response)
    response = image_process.call(:sketch, tmp_file, 'sketches')
    return handle_error(image_process.error) if image_process.error

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
    tmp_image
  end
end
