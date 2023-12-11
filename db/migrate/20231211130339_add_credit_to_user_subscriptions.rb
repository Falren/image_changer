class AddCreditToUserSubscriptions < ActiveRecord::Migration[7.1]
  def change
    add_column :user_subscriptions, :credit, :integer, default: 0
  end
end
