require "json"
require "open-uri"
require "rest-client"

class RestaurantsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def index
  end

  def search_restaurant
    if params[:location].present?
      coordinates = Geocoder.coordinates(params[:location])
      restaurants_creator = RestaurantsCreator.new(lat: coordinates[0], lng: coordinates[1], query: params[:name])
      @restaurants = restaurants_creator.fetch_restaurants
      @restaurants = Restaurant.order_by_distance(@restaurants, [params[:lat], params[:lng]])
    end
    respond_to do |format|
      format.html { redirect_to restaurants_path }
      format.js { render :file => "restaurants/search_nearby.js.erb" }
    end
  end

  def search_nearby
    if params[:ids].present?
      @restaurants = Restaurant.where(zoomato_place_id: JSON.parse(params[:ids]))
    else
      restaurants_creator = RestaurantsCreator.new(lat: params[:lat], lng: params[:lng])
      @restaurants = restaurants_creator.fetch_restaurants
    end
    @restaurants = Restaurant.order_by_distance(@restaurants, [params[:lat], params[:lng]])
    respond_to do |format|
      format.js
      format.html { redirect_to root_path }
    end
  end

  def show
    @restaurant = Restaurant.find_by(zoomato_place_id: params[:id])
    @list = @restaurant.user_list(current_user) if @restaurant.id
  end

  def filter
    degreesFilter = params[:degreesFilter].nil? ? [] : params[:degreesFilter]
    userFilter = params[:ownList].nil? ? false : params[:ownList] == "true"
    friendFilter = params[:friendIds].nil? ? [] : params[:friendIds].uniq.map { |id| User.find(id) }
    @filtered_restaurants = current_user.restaurants_filter(degrees: degreesFilter, with_own_list: userFilter, friends: friendFilter)
    respond_to do |format|
      format.json { render json: @filtered_restaurants }
    end
  end
end
