json.set! :user_restaurants do
  json.array! @restaurants do |restaurant|
    json.extract! restaurant, :zoomato_place_id, :name, :address, :photos, :price_level, :cuisines, :latitude, :longitude
  end
end

json.set! :friends do
  json.array! @following do |friend|
    json.extract! friend, :id, :name
    # binding.pry
    json.restaurants friend.restaurants.pluck(:zoomato_place_id)
  end
end

# json.set! :friend_favourites do
#   json.array! @following_restaurants do |r|
#     # binding.pry
#     json.extract! r[:restaurants]
#   end
# end

json.set! :friend_restaurants do
  json.array! @friend_restaurants do |restaurant|
    json.extract! restaurant, :zoomato_place_id, :name, :address, :photos, :latitude, :longitude
  end
end
