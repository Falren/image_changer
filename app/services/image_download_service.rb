class ImageDownloadService
  attr_accessor :error
  include ExternalImageProcessing

  def call(image)
    return set_error('No image provided') if image.nil?

    response = download_image(image.trans_id)
    parsed_response = parse_response(response)
    return set_error(parsed_response['msg']) if parsed_response['code']

    parsed_response
  end

  private

  def parse_response(response)
    begin
      JSON.parse(response)
    rescue JSON::ParserError
      response
    end
  end

  def set_error(message)
    @error = message
  end
end

