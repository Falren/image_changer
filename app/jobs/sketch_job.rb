class SketchJob < ApplicationJob
  include Rails.application.routes.url_helpers

  def perform(options)
    image = Image.find_by(id: options["image_id"])
    image_service = ImageDownloadService.new
    parsed_response = image_service.call(image)
    return handle_error(image_service.error) if image_service.error
    
    image.file.attach(
      io: StringIO.new(parsed_response.body), 
      filename: "image_sketch_#{image.trans_id}.jpg", 
      content_type: 'image/jpg'
    )
    broadcast_image_url(image)
  end

  private 

  def broadcast_image_url(image)
    ActionCable.server.broadcast("user_image_room:#{image.user_id}", image.file.url)
  end
end