class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  acts_as_token_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook]

  # association
  has_many :friendships, class_name: "Friendship",
                         foreign_key: "follower_id",
                         dependent: :destroy
  has_many :passive_friendships, class_name: "Friendship",
                                 foreign_key: "followed_id",
                                 dependent: :destroy

  has_many :followings, through: :friendships, source: :followed
  has_many :followers, through: :passive_friendships, source: :follower

  has_many :lists
  has_many :restaurants, through: :lists

  # validation
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates_presence_of :name
  #validates_format_of :email, with: VALID_EMAIL_REGEX

  # callbacks
  before_save { self.email = email.downcase }

  # instance methods
  def follow(another_user)
    followings << another_user
  end

  def unfollow(following_user)
    followings.delete(following_user)
  end

  def following?(another_user)
    followings.include?(another_user)
  end

  def follower?(another_user)
    followers.include?(another_user)
  end

  # refactor: 23 June, assumed only shown friends per degree. if not
  # it will affect which restos to be shown
  def second_degree_followings
    combined_followings = []
    # combined_followings << followings
    combined_followings << followings.map(&:followings)
    combined_followings.flatten.uniq - [self]
  end

  def third_degree_followings
    combined_followings = []
    # combined_followings << second_degree_followings
    combined_followings << second_degree_followings.map(&:followings)
    combined_followings.flatten.uniq - [self]
  end

  def add_restaurant(a_restaurant)
    restaurants << a_restaurant
  end

  def remove_restaurant(a_restaurant)
    self.restaurants -= [a_restaurant]
  end

  def friends_restaurants
    followings.map(&:restaurants).flatten.uniq
  end

  def second_degree_friends_restos
    second_degree_followings.map(&:restaurants).flatten.uniq
  end

  def third_degree_friends_restos
    third_degree_followings.map(&:restaurants).flatten.uniq
  end

  def restaurants_filter(options = {})
    return [] if options.empty?

    restaurants_arr = options[:with_own_list] ? [self.restaurants] : []

    filter_map = {
      "1" => lambda { friends_restaurants },
      "2" => lambda { second_degree_friends_restos },
      "3" => lambda { third_degree_friends_restos },
    }

    unless options[:degrees].blank?
      options[:degrees].each do |degree|
        restaurants_arr << filter_map[degree].call
      end
    end

    unless options[:friends].blank?
      options[:friends].each do |friend|
        restaurants_arr << friend.restaurants
      end
    end

    restaurants_arr.flatten.uniq
  end

  # class methods
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name   # assuming the user model has a name
      user.photo = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
