module Api
  class ImagesController < ApplicationController
    URL = 'https://www.cutout.pro/api/v1/cartoonSelfie?cartoonType=1'
    API_KEY = 'b2a93a5c901245ab94c9e1beccac2f57'
    
    def create
      return render json: { error: 'No file uploaded' }, status: :unprocessable_entity unless params[:file].present?

      uploaded_file = params[:file]
      saved_file_path = Rails.root.join('public', 'uploads', uploaded_file.original_filename)      
      response = send_file_to_external_api(saved_file_path)
      return render json: { error: 'Error processing the file' }, status: :unprocessable_entity if response.code != 200
      File.open(saved_file_path, 'wb') do |output_file|
        output_file.write(response.body)
        send_file(
          Rails.root.join('public', 'uploads', uploaded_file.original_filename),
          filename: uploaded_file.original_filename,
          type: uploaded_file.content_type,
          disposition: 'attachment'
        )
      end
    end

    private 
    
    def send_file_to_external_api(file_path)
      RestClient.post(
        URL,
        { file: File.new(file_path) },
        { APIKEY: API_KEY }
      )
    end
  end
end
