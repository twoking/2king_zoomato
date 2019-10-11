class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.references :restaurant, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :lists, [:restaurant_id, :user_id], unique: true
  end
end
