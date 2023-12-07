class AddTransIdToImages < ActiveRecord::Migration[7.1]
  def change
    add_column :images, :trans_id, :string
  end
end
