class CreditValidationService
  attr_reader :error

  def call(user)
    return set_error('No user provided') if user.nil?
    return set_error('No subscription') if user.user_subscription.nil?

    set_error('Insufficient credits') if user.user_subscription.credit.zero?
  end

  private
  
  def set_error(error)
    @error = error
  end
end
