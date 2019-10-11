class PagesController < ApplicationController
  def home
    @link = Link.create(user: current_user)
    # byebug
    # #@user_restaurants = current_user.restaurants
    # #@following = current_user.followings
    # #ids = []
    # #@following.map do |user|
    # #restaurants = user.restaurants.pluck(:id)
    # #ids <<  restaurants
    # #{ friend_id: user.id, restaurants: restaurants }
    # #end
    # @friend_restaurants = Restaurant.where(id: ids.flatten.uniq)
    # @restaurants = current_user.restaurants
    # @restaurants.each do |r|
    #   r.distance_from_me = (Geocoder::Calculations.distance_between([params[:lat], params[:lng]], [r.latitude, r.longitude]) * 10).round(2)
    # end
    # @restaurants = @restaurants.sort_by { |restaurant| restaurant.distance_from_me }
    # gon.restos = current_user.restaurants
  end
end
