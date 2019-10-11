class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.string :phone_number
      t.string :website
      t.float :latitude
      t.float :longitude
      t.string :place_id
      t.string :price_level
      t.text :photos, array: true, default: []
      t.text :opening_hours, array: true, default: []
      t.timestamps
    end
  end
end
