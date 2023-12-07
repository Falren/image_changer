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
    broadcast_image_url(image)
  end

  private 
  
  def broadcast_image_url(image)
    channel_name = "user_image_room:#{image.user_id}"
    ActionCable.server.broadcast(channel_name, image.file.url)
  end
end