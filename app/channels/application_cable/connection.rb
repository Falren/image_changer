require 'jwt'

module ApplicationCable        
  class Connection < ActionCable::Connection::Base 
    identified_by :current_user
 
    def connect                
      self.current_user = find_verified_user
    end
 
    private
    
    def find_user
      header = request.headers['Authorization']
      header = header.split(' ').last if header
      begin
        @decoded = JWT.decode(request.headers['Authorization'].split(' ')[1],
                             Rails.application.credentials.devise[:jwt_secret_key]).first
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
