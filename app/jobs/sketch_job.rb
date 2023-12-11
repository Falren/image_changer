class SketchJob < ApplicationJob
  include Rails.application.routes.url_helpers

  def perform(options)
    image = Image.find_by(id: options["image_id"])
    parsed_response = credit_download_service.call(image.user)
    return handle_error(credit_download_service.error) if credit_download_service.error
    
    image.file.attach(
      io: StringIO.new(parsed_response.body), 
      filename: "image_sketch_#{image.trans_id}.jpg", 
      content_type: 'image/jpg'
    )
    return handle_error(credit_validation_service.error) if credit_validation_service.call(image.user)
    
    broadcast_image_url(image)
  end

  private 

  def credit_download_service
    credit_download_service ||= ImageDownloadService.new
  end

  def credit_validation_service
    credit_validation_service ||= CreditValidationService.new
  end

  def broadcast_image_url(image)
    ActionCable.server.broadcast("user_image_room:#{image.user_id}", image.file.url)
  end
end