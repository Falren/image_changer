class ImageProcessService
  include ExternalImageProcessing
  attr_accessor :error
  
  def call(type, file, endpoint)
    parsed_response = JSON.parse(upload_image(file).body)
    return set_error(parsed_response['msg']) if parsed_response['code'] != 200

    parsed_response = JSON.parse(transform_image(parsed_response['data']['uid'], endpoint, type))
    return set_error(parsed_response['msg']) if parsed_response['code'] != 200
    
    parsed_response
  end

  private

  def set_error(message)
    @error = message
  end
end
