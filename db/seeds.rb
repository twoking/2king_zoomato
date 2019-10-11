
#creatigng restaurants
restaurants_creator = RestaurantsCreator.new(lat: -8.663641499999999, lng: 115.1467615)
@restaurants = restaurants_creator.fetch_restaurants
User.create(
  name: "Guido Caldara",
  email: "guido.caldara@gmail.com",
  password: "password",
)
#creating 10 users
15.times do
  User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: "password",
  )
end
#creating friendships
me = User.first
me.follow(User.all[1])
me.follow(User.all[2])
me.follow(User.all[3])
me.follow(User.all[5])

#creating random favourites restaurants
users = User.all[1..-1]
users.each do |user|
  user.add_restaurant(@restaurants.sample)
end
