const inputs = document.querySelectorAll(".friend-filter")
const restaurantsContainer =  document.querySelector("#restaurant-list")
const friendsContainer = document.querySelector("#friends-list")
let friendRestaurantFilter = []
// HTML Components
const restaurantCard = (restaurant) => {
  return `<a href="/restaurants/${restaurant.zoomato_place_id}"%>
  <div class="card-product my-2">
    <img src="${restaurant.photos[0]}">
    <div class="card-product-infos">
        <h2>${restaurant.name}</h2>
        <p class="my-0"><span class="resto-distance">${restaurant.address}</span></p>
        <p class="my-0 mr-1">${restaurant.price_level} | ${restaurant.cousines}</p>
    </div>
  </div>
` 
}

const friendInput = (friend) => {
  return (`<div class="form-check">
  <input class="friend-filter regular-checkbox" type="checkbox" id="user-friend-${friend.id}" value="${friend.id}">
  <label class="form-check-label" for="user-friend-${friend.id}">
    ${friend.name}
  </label>
</div>
`)
}

const filterList = (e) =>{
  if (e.target.checked) {
    friendRestaurantFilter.push(parseInt(e.target.value))
  } else {
    friendRestaurantFilter = friendRestaurantFilter.filter ((id) => { 
      return id !== parseInt(e.target.value) 
    })
  }

  const friendsList = dataList.friends.filter((value) => { return friendRestaurantFilter.includes(value.id)})
  const restaurantIdToDisplay = friendsList.map ((friend) => { return friend.restaurants })
  const restaurants = dataList.friend_restaurants.filter((restaurant) => { 
    return restaurantIdToDisplay.flat().includes(restaurant.zoomato_place_id)
  })
  displayRestaurantList(restaurants)
}


const appendRestaurant = (restaurant) => {
  restaurantsContainer.insertAdjacentHTML("afterbegin", restaurantCard(restaurant) )
} 

const appendFriend = (friend) => {
  friendsContainer.insertAdjacentHTML("afterbegin", friendInput(friend) )
}

const displayRestaurantList = (list) => {
  restaurantsContainer.innerHTML = ""
  list.forEach(restaurant => {
    appendRestaurant(restaurant)
  });
}

const selectAllCheckboxes = (e, inputs) => {
  friendRestaurantFilter = []
  inputs.forEach((input) => {
    if (input.checked) {
      input.checked = false
    }

    input.click()
  })
  
  if (e.target.classList.contains('blue-triangle')) {
    inputs.forEach(input => input.checked = false)
  }
}

async function displayFriendNames(friends) {
  for (const friend of friends) {
    await appendFriend(friend)
  };

  const inputs = document.querySelectorAll(".friend-filter")
  inputs.forEach(element => element.addEventListener("change", filterList))
  document.querySelector("#triangle").addEventListener("click", (e) => {
    // if (e.target.classList.contains('blue-triangle')) {
    //   console.log('ha')
    // } else {
      selectAllCheckboxes(e, inputs)
    // }
  })
}

const buildPage = (data) => {
  displayRestaurantList(data.user_restaurants)
  displayFriendNames(data.friends)
}

const initHomePage = () => {
  fetch("api/v1/restaurants")
    .then(response => response.json())
    .then((data) => {
      window.dataList = data 
      buildPage(data)
    });
}


export { initHomePage }