class CreateLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :links do |t|
      t.references :user, foreign_key: true
      t.string :token
      t.boolean :expired, default: false
      t.integer :count, default: 0
      t.timestamps
    end
  end
end
