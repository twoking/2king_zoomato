class Api::V1::RestaurantsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User, only: [:index]

  def index
    @restaurants = current_user.restaurants
    @user_restaurants = current_user.restaurants
    @first_degree_friend = current_user.followings
    @second_degree_friend = current_user.second_degree_followings
    @third_degree_friend = current_user.third_degree_followings

    @third_degree = current_user.third_degree_followings
    ids = []
    @first_degree_restaurants = current_user.restaurants_filter(options = { degrees: ["1"] })
    @second_degree_restaurants = current_user.restaurants_filter(options = { degrees: ["2"] })
    @third_degree_restaurants = current_user.restaurants_filter(options = { degrees: ["3"] })
    @restaurants_list = @first_degree_restaurants + @second_degree_restaurants + @third_degree_restaurants + @user_restaurants
  end
end
