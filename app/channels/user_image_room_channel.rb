class UserImageRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_image_room:#{current_user.id}"
  end

  def unsubscribed
    stop_all_streams
 end
end
