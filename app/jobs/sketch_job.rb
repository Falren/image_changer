class SketchJob < ApplicationJob
  include Rails.application.routes.url_helpers
  sidekiq_options retry: false

  def perform(options)
    image = Image.find_by(id: options["image_id"])
    credit_validation_service.call(image)
    return handle_error(credit_validation_service.error) if credit_validation_service.error
    
    parsed_response = image_download_service.call(image)
    return handle_error(image_download_service.error) if image_download_service.error
    
    image.file.attach(
      io: StringIO.new(parsed_response.body), 
      filename: "image_sketch_#{image.trans_id}.jpg", 
      content_type: 'image/jpg'
    )
    broadcast_image_url(image)
    image.user_subscription.update(credit: image.user_subscription.credit - 1)
  end

  private 

  def image_download_service
    @image_download_service ||= ImageDownloadService.new
  end

  def credit_validation_service
    @credit_validation_service ||= CreditValidationService.new
  end

  def broadcast_image_url(image)
    ActionCable.server.broadcast("user_image_room:#{image.user_id}", image.file.url)
  end
end