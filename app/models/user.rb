class User < ApplicationRecord
  TRIAL_CREDIT = 10
  devise :database_authenticatable, :registerable, :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
  
  has_many :images
  has_one :user_subscription
  has_one :subscription, through: :user_subscription
  validates :email, presence: true, uniqueness: true

  after_create :assign_trial_subscription

  def assign_trial_subscription
    subscription = Subscription.find_or_create_by(name: 'trial')

    create_user_subscription(subscription: subscription, credit: TRIAL_CREDIT)
  end
end
