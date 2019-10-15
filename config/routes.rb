Rails.application.routes.draw do
  root "pages#home"
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  resources :restaurants, only: [:index, :create, :show]
  # TODO: create a custom route for share link instead
  resources :lists, only: [:create, :destroy, :show]
  get "/restaurants-filter", to: "restaurants#filter", as: "restaurants-filter"
  post "users/follow/:id", to: "users#follow", as: "users_follow"
  get "search_nearby", to: "restaurants#search_nearby", as: "search_nearby"
  get "search_restaurant", to: "restaurants#search_restaurant", as: "search_restaurant"
  #get "list/:token" to: "users#user_list", as:"user_list"
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :restaurants, only: [:index]
    end
  end
end
