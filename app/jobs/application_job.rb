require 'sidekiq'

class ApplicationJob
  include Sidekiq::Job
  include ImageProcessing

  def handle_error(message)
    Rails.logger.error("Error in job: #{self.class.name} - #{message}")
  end
end
