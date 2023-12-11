class Image < ApplicationRecord
  belongs_to :user
  has_one :user_subscription, through: :user

  has_one_attached :file
end
