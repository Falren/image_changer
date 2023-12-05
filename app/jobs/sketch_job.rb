class SketchJob < ApplicationJob
  include Rails.application.routes.url_helpers

  def perform(options)
    image = Image.find_by(id: options["image_id"])
    response = download_image(image.trans_id)
    file = StringIO.new(response.body)
    image.file.attach(
      io: file, 
      filename: "image_sketch_#{image.trans_id}.jpg", 
      content_type: 'image/jpg'
    )
    url_for(image.file)
  end
end