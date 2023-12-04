module Api
  class ImagesController < ApplicationController
    def create
      return render json: { error: 'No file uploaded' }, status: :unprocessable_entity unless params[:file].present?

      process_image(:cartoonize, params[:file], 'cartoons') 
      render json: { status: :ok }
    end
  end
end