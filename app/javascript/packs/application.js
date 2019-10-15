import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!
import { listRestaurants } from "components/restaurants-nearby";
import { searchRestaurant } from "components/restaurant-search";
import { fetchRestaurantsNearBy } from "components/restaurants-nearby";
import { initAutocomplete } from "plugins/init_autocomplete";
import { initHomePage } from "components/home_page";


import "dom";
import "bootstrap";

const indexPage = document.querySelector("#search-restaurant-nearby");
indexPage && listRestaurants();
indexPage && fetchRestaurantsNearBy();
indexPage && searchRestaurant();
initHomePage();
initAutocomplete();
window.initAutocomplete = initAutocomplete



