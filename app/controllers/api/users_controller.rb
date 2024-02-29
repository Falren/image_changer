module Api
  class UsersController < ApplicationController
    before_action :authorize_request

    def index; end
  end
end
