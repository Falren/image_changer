require 'jwt'

module ApplicationCable        
  class Connection < ActionCable::Connection::Base 
    identified_by :current_user
 
    def connect                
      self.current_user = find_user
    end
 
    private
    
    def find_user
      token = request.params['token']
      token = token.split(' ').last if token
      begin
        @decoded = JWT.decode(token, Rails.application.credentials.devise[:jwt_secret_key]).first
        user_id = @decoded['sub']
        @current_user = User.find(user_id)
      rescue ActiveRecord::RecordNotFound => e
        reject_unauthorized_connection
      rescue JWT::DecodeError => e
        reject_unauthorized_connection
      end
    end
  end
end
