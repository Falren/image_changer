module Api
  class ImagesController < ApplicationController
    BASE_URL = 'https://api-service.vanceai.com/web_api/v1/'
    API_URL = {
      transform: 'transform',
      upload: 'upload',
      download: 'download'
    }
    JCONFIG = { sketch: {
      "job": "sketch",
      "config": {
        "module": "sketch",
        "module_params": {
          "model_name": "SketchStable",
          "single_face": true,
          "composite": true,
          "sigma": 0,
          "alpha": 0
        },
        "out_params": {}
      },
      cartoonize: 
      {
          "job": "cartoonize",
          "config": {
              "module": "cartoonize",
              "module_params": {
                  "model_name": "CartoonizeStable"
              }
          }
      }
    }}
    
    def create
      return render json: { error: 'No file uploaded' }, status: :unprocessable_entity unless params[:file].present?

      saved_file_path = Rails.root.join('public', 'uploads', uploaded_file.original_filename)
      image = File.open(saved_file_path, 'w') do |file|
        file.puts process_image(:cartoonize, params[:file]) 
      end
      image = File.open(saved_file_path, 'w') do |file|
        file.puts process_image(:sketch, image) 
      end

      send_file(
        image,
        filename: params[:file].original_filename,
        type: params[:file].content_type,
        disposition: 'attachment'
      )
    end

    private 

    def process_image(type, file)
      response = RestClient.post(
        BASE_URL + API_URL[:upload],
        {
          api_token: ENV['VANCE_API_KEY'],
          file: file
        }
      )
      uid = JSON.parse(response.body)['data']['uid']
      response = RestClient.post(
        BASE_URL + API_URL[:transform],
        {
          api_token: ENV['VANCE_API_KEY'],
          uid: uid,
          jconfig: JCONFIG[:sketch].to_json
        }
      )
      trans_id = JSON.parse(response.body)['data']['trans_id']
      response = RestClient.post(
        BASE_URL + API_URL[:download],
        {
          api_token: ENV['VANCE_API_KEY'],
          trans_id: trans_id
        }
      )
      response.body
    end
  end
end