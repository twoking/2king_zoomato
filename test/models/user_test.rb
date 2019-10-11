require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com", password: "test123")
    @michael = users(:michael)
    @resto_1 = restaurants(:resto_1)
    @resto_2 = restaurants(:resto_2)
    @resto_3 = restaurants(:resto_3)
    @resto_4 = restaurants(:resto_4)

    @michael  = users(:michael)
    @archer   = users(:archer)
    @lana     = users(:lana)
    @malory   = users(:malory)
  end

  test "validation validate" do
    assert @user.valid?
  end

  test "validation name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "validation email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "validation email should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "validation email should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "validation email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "validation email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "validation password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "validation password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "[restos] user should be able to add restaurant in his/her list" do
    @michael.add_restaurant(@resto_1)
    assert @michael.restaurants.include? @resto_1
  end

  test "[restos] user should be able to remove restaurant in his/her list" do
    @michael.add_restaurant(@resto_1)
    @michael.add_restaurant(@resto_2)
    @michael.remove_restaurant(@resto_1)
    assert_not @michael.restaurants.include? @resto_1
  end

  test "should let user see first degree friends restaurant_list" do
    @michael.follow @archer
    @michael.follow @lana

    @archer.add_restaurant(@resto_1)
    @lana.add_restaurant(@resto_2)

    filtered_restaurant = @michael.restaurants_filter(degrees: ["1"])

    assert filtered_restaurant.include? @resto_1
    assert filtered_restaurant.include? @resto_2
  end

  test "should let user see first degree friends restaurant_list and own restaurants" do
    @michael.follow @archer
    @michael.follow @lana

    @archer.add_restaurant(@resto_1)
    @michael.add_restaurant(@resto_2)

    filtered_restaurant = @michael.restaurants_filter(degrees: ["1"], with_own_list: true)

    assert filtered_restaurant.include? @resto_1
    assert filtered_restaurant.include? @resto_2
  end

  test "should let user see second degree friends restaurant_list ONLY" do
    @michael.follow @archer
    @archer.follow @lana

    @lana.add_restaurant(@resto_1)

    assert @michael.restaurants_filter(degrees: ["2"]).include? @resto_1
  end

  test "should let user see first & second degree friends restaurant_list ONLY" do
    @michael.follow @archer
    @archer.follow @lana

    @archer.add_restaurant(@resto_2)
    @lana.add_restaurant(@resto_1)

    filtered_restaurant = @michael.restaurants_filter(degrees: ["1", "2"])

    assert filtered_restaurant.include? @resto_1
    assert filtered_restaurant.include? @resto_2
  end

  test "should let user see first & second degree friends restaurant_list and own restaurants" do
    @michael.follow @archer
    @archer.follow @lana

    @archer.add_restaurant(@resto_2)
    @lana.add_restaurant(@resto_1)
    @michael.add_restaurant(@resto_3)

    filtered_restaurant = @michael.restaurants_filter(degrees: ["1", "2"], with_own_list: true)

    assert filtered_restaurant.include? @resto_1
    assert filtered_restaurant.include? @resto_2
    assert filtered_restaurant.include? @resto_3
  end

  test "should let user see third degree friends restaurant_list ONLY" do
    @michael.follow @archer
    @archer.follow @lana
    @lana.follow @malory

    @malory.add_restaurant(@resto_1)

    assert @michael.restaurants_filter(degrees: ["3"]).include? @resto_1
  end

  test "should let user see first & third degree friends restaurant_list ONLY" do
    @michael.follow @archer
    @archer.follow @lana
    @lana.follow @malory

    @archer.add_restaurant(@resto_1)
    @malory.add_restaurant(@resto_2)

    filtered_restaurant = @michael.restaurants_filter(degrees: ["1", "3"])

    assert filtered_restaurant.include? @resto_1
    assert filtered_restaurant.include? @resto_2
  end

  test "should let user see second & third degree friends restaurant_list ONLY" do
    @michael.follow @archer
    @archer.follow @lana
    @lana.follow @malory

    @lana.add_restaurant(@resto_1)
    @malory.add_restaurant(@resto_2)

    filtered_restaurant = @michael.restaurants_filter(degrees: ["2", "3"])

    assert filtered_restaurant.include? @resto_1
    assert filtered_restaurant.include? @resto_2
  end

  test "should let user see all degrees' friends restaurant_list ONLY" do
    @michael.follow @archer
    @archer.follow @lana
    @lana.follow @malory

    @archer.add_restaurant(@resto_1)
    @lana.add_restaurant(@resto_2)
    @malory.add_restaurant(@resto_3)

    filtered_restaurant = @michael.restaurants_filter(degrees: ["1", "2", "3"])

    assert filtered_restaurant.include? @resto_1
    assert filtered_restaurant.include? @resto_2
  end

  test "should let user see all degrees' friends restaurant_list and own restaurant" do
    @michael.follow @archer
    @archer.follow @lana
    @lana.follow @malory

    @archer.add_restaurant(@resto_1)
    @lana.add_restaurant(@resto_2)
    @malory.add_restaurant(@resto_3)
    @michael.add_restaurant(@resto_4)

    filtered_restaurant = @michael.restaurants_filter(degrees: ["1", "2", "3"], with_own_list: true)

    assert filtered_restaurant.include? @resto_1
    assert filtered_restaurant.include? @resto_2
  end

  test "should let user see a specific friend's restaurant_list" do
    @michael.follow @archer
    @michael.follow @malory

    @archer.add_restaurant(@resto_1)
    @archer.add_restaurant(@resto_2)
    @malory.add_restaurant(@resto_3)

    filtered_restaurant = @michael.restaurants_filter(friends: [@archer])

    assert filtered_restaurant.include? @resto_1
    assert filtered_restaurant.include? @resto_2
    assert_not filtered_restaurant.include? @resto_3
  end

  test "should let user see multiple friends restaurant_list" do
    @michael.follow @archer
    @michael.follow @malory
    @michael.follow @lana

    @archer.add_restaurant(@resto_1)
    @archer.add_restaurant(@resto_2)
    @malory.add_restaurant(@resto_3)
    @lana.add_restaurant(@resto_4)

    filtered_restaurant = @michael.restaurants_filter(friends: [@archer, @malory])

    assert filtered_restaurant.include? @resto_1
    assert filtered_restaurant.include? @resto_3
    assert_not filtered_restaurant.include? @resto_4
  end

  test "should filter restaurant by friends uniquely" do
    @michael.follow @archer
    @michael.follow @malory

    @archer.add_restaurant(@resto_1)
    @malory.add_restaurant(@resto_1)

    assert_equal @michael.restaurants_filter(friends: [@archer, @malory]).count { |resto| resto == @resto_1 }, 1
  end
end
