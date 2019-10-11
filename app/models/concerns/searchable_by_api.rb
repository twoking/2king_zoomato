module SearchableByApi

  extend ActiveSupport::Concern
  module ClassMethods
    def api_search(place_id)
      url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=#{place_id}&fields=address_component,adr_address,alt_id,formatted_address,address_component,geometry,icon,id,name,permanently_closed,photo,place_id,plus_code,scope,type,url,utc_offset,vicinity,formatted_phone_number,website,price_level,opening_hours,rating,review,user_ratings_total&key=#{ENV['GOOGLE_API_KEY']}"
      resto_serialized = open(url).read
      restaurant_json = JSON.parse(resto_serialized)
      restaurant = Restaurant.new(
        name: restaurant_json["result"]["name"],
        address: restaurant_json["result"]["formatted_address"],
        phone_number: restaurant_json["result"]["formatted_phone_number"],
        place_id: restaurant_json["result"]["place_id"],
        latitude: restaurant_json["result"]["geometry"]["location"]["lat"],
        longitude: restaurant_json["result"]["geometry"]["location"]["lng"],
        price_level: restaurant_json["result"]["price_level"],
        website: restaurant_json["result"]["website"],
        opening_hours: restaurant_json["result"]["opening_hours"]["weekday_text"]
      )
      restaurant_json["result"]["photos"][0..3].map do |photo|
        restaurant.photos << "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{photo["photo_reference"]}&key=#{ENV['GOOGLE_API_KEY']}"
      end
      return restaurant
    end
  end
end
