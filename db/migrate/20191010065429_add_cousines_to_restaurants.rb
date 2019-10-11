class AddCousinesToRestaurants < ActiveRecord::Migration[5.2]
  def change
    add_column :restaurants, :cuisines, :string
    add_column :restaurants, :timings, :string
  end
end
