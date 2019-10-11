import { startSpinner } from './start_spinner.js'


const searchRestaurant = () => {
  const searchBtn = document.querySelector("#search-restaurant")
  if (searchBtn){
    searchBtn.addEventListener("click", startSpinner)
  }
}

export { searchRestaurant }

