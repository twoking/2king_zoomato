class Api::V1::RestaurantsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, only: [:index]

  def index
    @restaurants = current_user.restaurants
    @user_restaurants = current_user.restaurants
    @following = current_user.followings
    ids = []
    @following_restaurants = @following.map do |user|
      restaurants = user.restaurants.pluck(:id)
      ids << restaurants
      { friend_id: user.id, restaurants: restaurants }
    end
    @friend_restaurants = Restaurant.where(id: ids.flatten.uniq)
  end
end
