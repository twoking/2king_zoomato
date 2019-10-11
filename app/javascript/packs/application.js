import { listRestaurants } from "components/restaurants-nearby";
import { searchRestaurant } from "components/restaurant-search";
import { fetchRestaurantsNearBy } from "components/restaurants-nearby";
import { initAutocomplete } from "plugins/init_autocomplete";

import "dom";
import "bootstrap";

const indexPage = document.querySelector("#search-restaurant-nearby");
indexPage && listRestaurants();
indexPage && fetchRestaurantsNearBy();
indexPage && searchRestaurant();

initAutocomplete();
window.initAutocomplete = initAutocomplete