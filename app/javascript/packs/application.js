import { listRestaurants } from "components/restaurants-nearby";
import { searchRestaurant } from "components/restaurant-search";
import { fetchRestaurantsNearBy } from "components/restaurants-nearby";
import { initAutocomplete } from "plugins/init_autocomplete";
import { initHomePage } from "components/home_page";

import "dom";
import "bootstrap";

const indexPage = document.querySelector("#search-restaurant-nearby");
const homePage = document.querySelector(".map-wrapper");
indexPage && listRestaurants();
indexPage && fetchRestaurantsNearBy();
indexPage && searchRestaurant();
homePage && initHomePage();
initAutocomplete();
window.initAutocomplete = initAutocomplete;
