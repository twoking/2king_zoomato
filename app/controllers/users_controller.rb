class UsersController < ApplicationController

  def follow
    @user = current_user
    @user_to_follow = User.find(params[:id])
    @user.follow(@user_to_follow)
    redirect_to root_path
    flash[:notice] = "You added #{@user_to_follow.name} to your list!"
  end
end
