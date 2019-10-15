class Restaurant < ApplicationRecord
  attr_accessor :distance_from_me
  include SearchableByApi
  validates_presence_of :zoomato_place_id, :name, :address
  has_many :lists, dependent: :destroy

  #List ID based on current_user and restaurant
  def user_list(user)
    List.find_by(restaurant: self, user: user)
  end

  def display_price_level
    string = ""
    self.price_level.to_i.times { string.concat("$") }
    string
  end

  def display_distance
    number = self.distance_from_me
    if number >= 1
      return "#{number.round(1)}Km away"
    elsif number < 1
      return "#{(number * 100).round(0)}m away"
    end
  end

  def self.order_by_distance(resto, params)
    resto.each do |r|
      r.distance_from_me = (Geocoder::Calculations.distance_between(params, [r.latitude, r.longitude]) ).round(2)
    end
    resto.sort_by { |restaurant| restaurant.distance_from_me }
  end
end
