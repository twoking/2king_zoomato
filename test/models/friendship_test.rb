require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  def setup
    @friendship = Friendship.new(follower_id: users(:michael).id,
                                     followed_id: users(:archer).id)
    @michael  = users(:michael)
    @archer   = users(:archer)
    @lana     = users(:lana)
    @malory   = users(:malory)
  end

  test "should be valid" do
    assert @friendship.valid?
  end

  test "should require a follower_id" do
    @friendship.follower_id = nil
    assert_not @friendship.valid?
  end

  test "should require a followed_id" do
    @friendship.followed_id = nil
    assert_not @friendship.valid?
  end

  test "should return false if michael hasn't follow archer" do
    assert_not @michael.following?(@archer)
  end

  test "should let michael to follow archer" do
    @michael.follow @archer
    assert @michael.following?(@archer)
  end

  test "should let michael to unfollow archer" do
    @michael.unfollow @archer
    assert_not @michael.following?(@archer)
  end

  test "should let user sees who has followed him/her" do
    @michael.follow @archer
    assert @archer.follower? @michael
  end

  test "should let user sees his/her second degree friends" do
    @michael.follow @archer
    @archer.follow @lana
    assert @michael.second_degree_followings.include? @lana
    assert_not @michael.third_degree_followings.include? @archer
  end

  test "user friend should recur once in the second degree list" do
    @michael.follow @archer
    @michael.follow @malory
    @archer.follow @lana
    @malory.follow @lana

    assert_equal @michael.second_degree_followings.count { |user| user == @lana }, 1
  end

  test "should exclude the user him/herself from his/her second degree friends" do
    @michael.follow @archer
    @archer.follow @michael
    assert_not @michael.second_degree_followings.include? @michael
  end

  test "should let user sees his/her third degree friends" do
    @michael.follow @archer
    @archer.follow @lana
    @lana.follow @malory
    assert @michael.third_degree_followings.include? @malory
    assert_not @michael.third_degree_followings.include? @lana
    assert_not @michael.third_degree_followings.include? @archer
  end

  test "user friend should recur once in the third degree list" do
    @michael.follow @archer
    @archer.follow @malory
    @malory.follow @lana

    user_4 = users(:user_4)
    @archer.follow user_4
    user_4.follow @lana

    assert_equal @michael.third_degree_followings.count { |user| user == @lana }, 1
  end

  test "should exclude the user him/herself from his/her third degree friends" do
    @michael.follow @archer
    @archer.follow @lana
    @lana.follow @michael
    assert_not @michael.third_degree_followings.include? @michael
  end
end
