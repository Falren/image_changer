class UserImageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_image_#{current_user.id}"
  end

  def unsubscribed
    stop_all_streams
 end
end
