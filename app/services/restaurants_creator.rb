class RestaurantsCreator < ApplicationService
  def initialize(params)
    @lat = params[:lat]
    @lng = params[:lng]
    @query = params[:query] || nil
  end

  def fetch_restaurants
    url = @query ? search_restaurant : restaurant_nearby
    results = RestClient.get(url, headers = { "user-key": ENV["ZOOMATO_API"] })
    results = JSON.parse(results)
    @restaurants = []
    results["restaurants"].each do |restaurant|
      existing_restaurant = Restaurant.find_by(zoomato_place_id: restaurant["restaurant"]["id"].to_i)
      if existing_restaurant
        @restaurants << existing_restaurant
        next
      end
      begin
        new_restaurant = {}
        new_restaurant[:photos] = []
        new_restaurant[:name] = restaurant["restaurant"]["name"]
        new_restaurant[:address] = restaurant["restaurant"]["location"]["address"]
        new_restaurant[:latitude] = restaurant["restaurant"]["location"]["latitude"]
        new_restaurant[:longitude] = restaurant["restaurant"]["location"]["longitude"]
        new_restaurant[:cuisines] = restaurant["restaurant"]["cuisines"]
        new_restaurant[:price_level] = restaurant["restaurant"]["price_range"]
        new_restaurant[:zoomato_place_id] = restaurant["restaurant"]["id"].to_i
        new_restaurant[:phone_number] = restaurant["restaurant"]["phone_numbers"]
        new_restaurant[:timings] = restaurant["restaurant"]["timings"]
        new_restaurant[:photos] << restaurant["restaurant"]["featured_image"]
        if restaurant["restaurant"]["photos"]
          restaurant["restaurant"]["photos"].each do |photo|
            new_restaurant[:photos] << photo["photo"]["url"]
          end
        end
        @restaurants << Restaurant.create(new_restaurant)
      rescue
        puts "Some Problems"
        next
      end
    end
    @restaurants
  end

  def restaurant_nearby
    url = "https://developers.zomato.com/api/v2.1/search?count=15&lat=#{@lat}&lon=#{@lng}&radius=200&sort=real_distance&order=asc"
  end

  def search_restaurant
    url = "https://developers.zomato.com/api/v2.1/search?q=#{@query}&lat=#{@lat}&lon=#{@lng}&radius=100"
    #https://developers.zomato.com/api/v2.1/search?q=moana&lat=-8.6478175&lon=115.1385192&radius=1000

  end
end
