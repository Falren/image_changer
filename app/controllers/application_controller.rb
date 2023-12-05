class ApplicationController < ActionController::API
  include WebApiConstants

  def process_image(type, file, endpoint)
    response = upload_image(file)
    uid = JSON.parse(response.body)['data']['uid']
    response = transform_image(uid, endpoint, type)
    trans_id = JSON.parse(response.body)['data']['trans_id']
    response
  end

  private 
  
  def upload_image(file)
    RestClient.post(
      BASE_URL + API_URL[:upload],
      {
        api_token: ENV['VANCE_API_KEY'],
        file: file
      }
    )
  end

  def transform_image(uid, endpoint, type)
    RestClient.post(
      BASE_URL + API_URL[:transform],
      {
        api_token: ENV['VANCE_API_KEY'],
        uid: uid,
        webhook: "https://3dfe-212-55-78-50.ngrok-free.app/webhooks/#{endpoint}",
        jconfig: JCONFIG[type].to_json
      }
    )
  end

  def download_image
    RestClient.post(
      BASE_URL + API_URL[:download],
      {
        api_token: ENV['VANCE_API_KEY'],
        trans_id: params[:trans_id]
      }
    )
  end
end
