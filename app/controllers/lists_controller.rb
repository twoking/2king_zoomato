class ListsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @link = Link.find_by(token: params[:id])
    if @link.nil?
      redirect_to root_path
      flash[:alert] = "The link you are trying to access doesn't exist"
    else
      @user = @link.user
      @restaurants = @user.restaurants
      @link.count = @link.count + 1
      @link.save
      gon.markers = @user.restaurants.map { |resto| [resto.latitude, resto.longitude] }
    end
  end


  def create
    restaurant = Restaurant.find(params[:restaurant_id])
    @list = List.create(user: current_user, restaurant: restaurant)
    respond_to do |format|
      format.js
      format.html { redirect_to root_path }
    end
  end

  def destroy
    @list = List.find(params[:id])
    @restaurant = @list.restaurant
    @list.destroy
    respond_to do |format|
      format.js
      format.html { redirect_to root_path }
    end
  end
end
