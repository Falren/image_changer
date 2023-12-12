class CartoonJob < ApplicationJob
  sidekiq_options retry: false

  def perform(options)
    image = Image.find_by(id: options["image_id"])
    parsed_response = image_download_service.call(image)
    return handle_error(image_download_service.error) if image_download_service.error
    
    tmp_file = process_temp_image(image.trans_id, parsed_response)
    response = image_process_service.call(:sketch, tmp_file, 'sketches')
    return handle_error(image_process_service.error) if image_process_service.error

    image.update(trans_id: response['data']['trans_id'])
  end

  private

  def image_download_service
    @image_download_service ||= ImageDownloadService.new
  end

  def image_process_service
    @image_process_service ||= ImageProcessService.new
  end

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
