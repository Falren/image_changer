class CartoonJob < ApplicationJob
  def perform(options)
    image = Image.find_by(id: options["image_id"])
    response = download_image(image.trans_id)
    tmp_image = Tempfile.new(["temp_image_#{image.trans_id}",'.jpg'])
    tmp_image.set_encoding('ASCII-8BIT')
    tmp_image.write response.body
    tmp_image.rewind
    trans_id = process_image(:sketch, tmp_image, 'sketches')
    image.update(trans_id: trans_id)
  end
end