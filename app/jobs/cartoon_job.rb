class CartoonJob < ApplicationJob
  def perform(options)
    image = find_image(options["image_id"])
    return unless image

    tmp_image = download_and_tempfile(image.trans_id)
    return unless tmp_image

    trans_id = process_temp_image(tmp_image)
    return if trans_id.nil?

    image.update(trans_id: trans_id)
  end

  private

  def find_image(image_id)
    Image.find_by(id: image_id)
  end

  def download_and_tempfile(trans_id)
    response = download_image(trans_id)
    return unless response.success?

    tmp_image = Tempfile.new(["temp_image_#{image.trans_id}",'.jpg'])
    tmp_image.set_encoding('ASCII-8BIT')
    tmp_image.write response.body
    tmp_image.rewind
  end

  def process_temp_image(tmp_image)
    process_image(:sketch, File.open(tmp_image), 'sketches')
  end
end
