const restaurantsContainer =  document.querySelector("#restaurant-list")
const friendsContainer = document.querySelector("#friends-list")
let friendsIdsToDisplay = []
let restaurantsIdToDisplay = []
let datas = new Array; 
let degreeToDisplay = [0]
let first_degree_friends_restaurants_id = new Array; 
let second_degree_friends_restaurants_id = new Array; 
let third_degree_friends_restaurants_id = new Array; 
let my_restaurants_id =  new Array; 



// HTML Components
//Restaurant Card
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

//Checkboxes based on the friend's list
const friendInput = (friend) => {
  return (`<div class="form-check">
  <input class="friend-filter regular-checkbox" type="checkbox" id="user-friend-${friend.id}" value="${friend.id}">
  <label class="form-check-label" for="user-friend-${friend.id}">
    ${friend.name}
  </label>
</div>
`)
}


const appendRestaurant = (restaurant) => {
  restaurantsContainer.insertAdjacentHTML("afterbegin", restaurantCard(restaurant) )
} 

const appendFriend = (friend) => {
  friendsContainer.insertAdjacentHTML("afterbegin", friendInput(friend) )
}

//BLUE FRIEND CHECKBOXES
//Add and rmeove single Friends (friend's name checkbox)

//Get restaurants based on an array of friends
const updateREstaurantList = () => {
  const friendsList = datas.first_degree_friend.filter((value) => { return friendsIdsToDisplay.includes(value.id)})
  restaurantsIdToDisplay = friendsList.map ((friend) => { return friend.restaurants }).flat()
  const restaurants = datas.friend_restaurants.filter((restaurant) => { 
    return restaurantsIdToDisplay.flat().includes(restaurant.zoomato_place_id)
  })
  displayRestaurantList(restaurants)
}

const addFriendToList = (id) => {
  friendsIdsToDisplay.push(parseInt(id))
  updateREstaurantList()
}

const removeFriendToList = (id) => {
  friendsIdsToDisplay = friendsIdsToDisplay.filter((friend) =>  friend != parseInt(id) )
  updateREstaurantList()
}


//Toggle checkboxes
const filterList = (e) =>{
  if (e.target.checked) {
    addFriendToList(e.target.value);
  } else {
    removeFriendToList(e.target.value)
  }
}
// DIsplay friend name and add listener to all of them
async function displayFriendNames(friends) {
  for (const friend of friends) {
    await appendFriend(friend)
  };

  const inputs = document.querySelectorAll(".friend-filter")
  inputs.forEach(element => element.addEventListener("change", filterList))
  document.querySelector("#triangle").addEventListener("click", (e) => {
    degreeToDisplay = []
    multipleCheckboxesSelection(e, inputs)
  })
}








// DIsplay all the restaurants based on the degree
const getRestaurantsByIds = () => {
  let ids = []
  if (degreeToDisplay.includes(0)) ids.push(my_restaurants_id)
  if (degreeToDisplay.includes(1)) ids.push(first_degree_friends_restaurants_id)
  if (degreeToDisplay.includes(2)) ids.push(second_degree_friends_restaurants_id)
  if (degreeToDisplay.includes(3)) ids.push(third_degree_friends_restaurants_id)
  let restaurants = []
  ids = ids.flat()
    restaurants = datas.friend_restaurants.filter((restaurant) => {
      console.log(restaurant.zoomato_place_id)
     return ids.includes(restaurant.zoomato_place_id)
   })  
   const uniq = new Set(restaurants.map(e => JSON.stringify(e)));
   restaurants = Array.from(uniq).map(e => JSON.parse(e));
   displayRestaurantList(restaurants)
}



const updateDisplayDegreeList = (degree) =>{
  if (degreeToDisplay.includes(degree)){
    degreeToDisplay = degreeToDisplay.filter(e => e != degree)
  } else{
    degreeToDisplay.push(degree)
  }

}

const updateIdsList = async (number) => {
  await updateDisplayDegreeList(parseInt(number))
  getRestaurantsByIds()

}




//ListFiltering
const listFiltering = () => {
  const filterList = document.querySelectorAll(".restaurant-filter");
  filterList.forEach((checkbox) => {
    checkbox.addEventListener("change", (e) => {
      updateIdsList(e.target.value)
    })
  })
}





const displayRestaurantList = (list) => {
  restaurantsContainer.innerHTML = ""
  list.forEach(restaurant => {
    appendRestaurant(restaurant)
  });
}

const multipleCheckboxesSelection = (e, inputs) => {
  restaurantsIdToDisplay = []
  let isChecked = e.target.classList.contains("blue-triangle")
  if (isChecked){
    displayRestaurantList(datas.user_restaurants)
  }
  inputs.forEach((input) => {
    if (isChecked){
      if (input.checked) {
        input.checked = false
      }  
    } else {
      if (input.checked) input.checked = false
      input.click()    
      }
    })
  }


const buildPage = (data) => {
  displayRestaurantList(data.user_restaurants)
  displayFriendNames(data.first_degree_friend)
  listFiltering()
}

const initHomePage = () => {
  fetch("api/v1/restaurants")
    .then(response => response.json())
    .then((data) => {
      datas = data
      my_restaurants_id =  data.user_restaurants.map((restaurant) => restaurant.zoomato_place_id ).flat()
      first_degree_friends_restaurants_id = data.first_degree_friend.map((friend) => friend.restaurants ).flat()
      second_degree_friends_restaurants_id = data.second_degree_friend.map((friend) => friend.restaurants ).flat()
      third_degree_friends_restaurants_id = data.third_degree_friend.map((friend) => friend.restaurants ).flat()
      buildPage(data)
    });
}


export { initHomePage }