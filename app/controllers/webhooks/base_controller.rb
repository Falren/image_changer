module Webhooks
  class BaseController < ApplicationController
    def image
      @image ||= Image.find_by(trans_id: params[:trans_id])
    end

    def image_user
      return if image.nil?
      
      image.user
    end
  end
end
