module Webhooks 
  class SketchesController < BaseController
    def index
      response = download_image
      saved_file_path = Rails.root.join('public', 'uploads', 'test_pic.jpg')
      File.open(saved_file_path, 'wb') do |file|
        file.puts response.body
      end
      image = File.open(saved_file_path, 'rb')
      render json: { status: :ok }
    end
  end
end