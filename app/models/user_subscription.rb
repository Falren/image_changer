class UserSubscription < ApplicationRecord
  belongs_to :user
  belongs_to :subscription

  validates :credit, numericality: { greater_than_or_equal_to: 0 }
end
