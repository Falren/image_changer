module ImageProcessing
  extend ActiveSupport::Concern
  include WebApiConstants
  
  def process_image(type, file, endpoint)
    parsed_response = JSON.parse(upload_image(file).body)
    return parsed_response if parsed_response['code'] != 200

    JSON.parse(transform_image(parsed_response['data']['uid'], endpoint, type)) 
  end
  
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
        webhook: "https://#{ENV['DOMAIN']}/webhooks/#{endpoint}",
        jconfig: JCONFIG[type].to_json
      }
    )
  end

  def download_image(trans_id)
    RestClient.post(
      BASE_URL + API_URL[:download],
      {
        api_token: ENV['VANCE_API_KEY'],
        trans_id: trans_id
      }
    )
  end
end