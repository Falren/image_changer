class CreateUserSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :user_subscriptions do |t|
      t.references :user, foreign_key: true
      t.references :subscription, foreign_key: true

      t.timestamps
    end
  end
end
