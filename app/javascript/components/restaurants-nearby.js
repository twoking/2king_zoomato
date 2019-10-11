import haversine from "haversine"
import { startSpinner } from './start_spinner.js'


const getCurrentLocation = (callback) => {
  let newPosition = false
  let distance = 100
  const lat = document.querySelector("#current_lat_field")
  const lng = document.querySelector("#current_lng_field")
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      if (localStorage.getItem('lat')){
        let start = {latitude: parseFloat(localStorage.getItem('lat')), longitude: parseFloat(localStorage.getItem('lng'))}
        let end = {latitude: position.coords.latitude, longitude: position.coords.longitude}
        distance = haversine(start, end)
        localStorage.setItem('lat', `${position.coords.latitude}`);
        localStorage.setItem('lng', `${position.coords.longitude}`);
      } else {
        localStorage.setItem('lat', `${position.coords.latitude}`);
        localStorage.setItem('lng', `${position.coords.longitude}`);
        newPosition = true
      }
      if (distance > 0.5 ){
        localStorage.setItem('lat', `${position.coords.latitude}`);
        localStorage.setItem('lng', `${position.coords.longitude}`);
        newPosition = true
      }
      lat.value = localStorage.getItem('lat')
      lng.value = localStorage.getItem('lng')  
      callback(newPosition)
    });
  } else {
    throw new Error("Your browser does not support geolocation.");
  }
}



const listRestaurants = () => {
  getCurrentLocation((newPosition) => {
    const form = document.querySelector("#search_nearby_form")
    const lat = localStorage.getItem('lat');
    const lng = localStorage.getItem('lng');
    const restaurants = localStorage.getItem('restaurants');
    console.log(restaurants)
    const field = document.querySelector("#stored_restaurants")
    if (restaurants != null && !newPosition) {
      console.log("Displaying stored restos");
      field.value = restaurants
      Rails.fire(form, "submit")
      startSpinner()
    } else {
      console.log("New Search");
      field.value = null
      Rails.fire(form, "submit")
      startSpinner()
    }
  });
}

const fetchRestaurantsNearBy = () => {
  let btn = document.querySelector("#search-restaurant-nearby")
  btn.addEventListener("click",(e)=> {
    e.preventDefault()
    localStorage.removeItem('restaurants');
    listRestaurants()
  })
}
export {
  listRestaurants, fetchRestaurantsNearBy
}
