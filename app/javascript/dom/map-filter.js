import { intersection } from "lodash"
import { initMap, setMapOnAll, deleteMarkers, addMarker, map, markers } from '../plugins/map'

$(function() {
  if($('#map')) {
    navigator.geolocation.getCurrentPosition(success, error, options);
    initDegreeFilter();
    initFriendFilter();
  }
});

const options = {
  enableHighAccuracy: true,
  timeout: 5000,
  maximumAge: 0
};

const success = (pos) => {
  const {latitude, longitude} = pos.coords;
  initMap(latitude, longitude)
}

const error = (err) => {
  console.warn(`ERROR(${err.code}): ${err.message}`);
}

const callRestaurantFilter = (payload) => {
  deleteMarkers();
  $.get('/restaurants-filter.json', payload, function(restos) {
    console.log(restos)
    restos.forEach(({name, price_level, latitude: lat, longitude: lng, place_id}) => {
      addMarker({name, price_level, lat, lng, place_id});
    })
    setMapOnAll(map);
    updateRestaurantDisplay(restos)
  });
}

const updateRestaurantDisplay = (restos) => {
  const $mainPanel = $('#main-panel');
  $mainPanel.empty();

  restos.forEach(resto => {
    const $card = `
    <a class="mx-2 restaurant-card-link" href="/restaurants/${resto.place_id}">
      <div class="card-product">
        <img src="${resto.photos[0]}">
        <div class="card-product-infos">
          <h2>${resto.name}</h2>
          <p>${resto.price_level || ''}</p>
          <p>${resto.address}</p>
        </div>
      </div>
    </a>`

    // TODO: how to get ruby instance method on js?
    // <p>${resto.open_now? ? 'OPEN' : 'CLOSED'}</p>

    $mainPanel.append($card);
  })
}

const initDegreeFilter = () => {
  const $restaurantFilter = $('.restaurant-filter');

  $restaurantFilter.on('change', function(e) {
    const degreesFilter = [];
    let ownList = false;

    $.each($(".restaurant-filter:checked"), function(){
      if($(this).hasClass('user-filter')) {
        ownList = $(this).prop('checked');
      } else {
        degreesFilter.push($(this).val());
      }
    });

    const payload = {
      degreesFilter,
      ownList
    };

    callRestaurantFilter(payload);
  });
}

const initFriendFilter = () => {
  const $friendFilter = $('.friend-filter');

  $friendFilter.on('change', function(e) {
    const friendIds = [];

    $.each($(".friend-filter:checked"), function(){
      friendIds.push(this.value);
    });

    callRestaurantFilter({ friendIds });
  });
}
