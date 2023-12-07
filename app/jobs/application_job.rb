require 'sidekiq'

class ApplicationJob
  include Sidekiq::Job
  include ImageProcessing
end
