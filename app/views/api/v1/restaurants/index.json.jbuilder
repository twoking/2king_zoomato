json.set! :user_restaurants do
  json.array! @restaurants do |restaurant|
    json.extract! restaurant, :zoomato_place_id, :name, :address, :photos, :price_level, :cuisines, :latitude, :longitude
  end
end

json.set! :first_degree_friend do
  json.array! @first_degree_friend do |friend|
    json.extract! friend, :id, :name
    json.restaurants friend.restaurants.pluck(:zoomato_place_id)
  end
end

json.set! :second_degree_friend do
  json.array! @second_degree_friend do |friend|
    json.extract! friend, :id, :name
    json.restaurants friend.restaurants.pluck(:zoomato_place_id)
  end
end

json.set! :third_degree_friend do
  json.array! @third_degree_friend do |friend|
    json.extract! friend, :id, :name
    json.restaurants friend.restaurants.pluck(:zoomato_place_id)
  end
end

json.set! :friend_restaurants do
  json.array! @restaurants_list do |restaurant|
    json.extract! restaurant, :zoomato_place_id, :name, :address, :photos, :latitude, :longitude
  end
end
