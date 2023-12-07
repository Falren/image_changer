class SketchJob < ApplicationJob
  include Rails.application.routes.url_helpers

  def perform(options)
    image = Image.find_by(id: options["image_id"])
    response = download_image(image.trans_id)
    image.file.attach(
      io: StringIO.new(response.body), 
      filename: "image_sketch_#{image.trans_id}.jpg", 
      content_type: 'image/jpg'
    )
    ActionCable.server.broadcast("user_image_room:#{image.user_id}", image.file.url)
  end
end