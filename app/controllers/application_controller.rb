class ApplicationController < ActionController::Base
  before_action :store_current_location, unless: :devise_controller?
  protect_from_forgery with: :exception
  before_action :authenticate_user!

 private
  def store_current_location
    store_location_for(:user, request.url)
  end
  def after_sign_out_path_for(resource)
    request.referrer || root_path
  end
end
