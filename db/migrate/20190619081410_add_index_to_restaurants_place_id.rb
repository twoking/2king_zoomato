class AddIndexToRestaurantsPlaceId < ActiveRecord::Migration[5.2]
  def change
    add_index :restaurants, :place_id, unique: true
  end
end
