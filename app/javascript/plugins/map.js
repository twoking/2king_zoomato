const images = require.context('../images', true);
const imagePath = (name) => images(name, true)

let map;
let markers = [];
let prev_infowindow = false;

const $infoWindow = $('#info-window')

const setupInfoWindow = (marker, {name, price_level, place_id}) => {
  const price_level_label = price_level ? "$".repeat(price_level) : ''
  const contentString = `
    <a href="/restaurants/${place_id}">
      ${name} ${ price_level_label ? ' | ' + price_level_label : ''}
      <i class="fas fa-chevron-right"></i>
    </a>
  `;

  marker.addListener('click', function() {
    $infoWindow.html(contentString);
    $infoWindow.removeClass('invisible');
  });
}

const addMarker = ({name, price_level, lat, lng, place_id}, isResto = true) => {
  const marker = new google.maps.Marker({
    position: { lat, lng },
    map: map,
    icon: imagePath('./blue-dot.png')
  });

  if(isResto) {
    marker.icon = imagePath('./crown.png');
    setupInfoWindow(marker, {name, price_level, place_id});
  }

  markers.push(marker);
}

// delete all markers minus the current user position marker
const deleteMarkers = () => {
  clearMarkers();
  markers = [markers[0]];
}

const clearMarkers = () => {
  setMapOnAll(null);
}

const setMapOnAll = (map) => {
  markers.slice(1).forEach(marker => {
    marker.setMap(map);
  })
}

const initMap = (lat, lng, zoom = 15) => {
  const myCoords = new google.maps.LatLng(lat, lng);
  const mapOptions = {
    disableDefaultUI: true,
    center: myCoords,
    zoom
  };

  map = new google.maps.Map(document.getElementById('map'), mapOptions);
  const currentPosition = {
    lat: myCoords.lat(),
    lng: myCoords.lng()
  }
  addMarker(currentPosition, false);

  if (gon.restos.length) {
    gon.restos.forEach(({name, price_level, latitude: lat, longitude: lng, place_id}) => {
      addMarker({name, price_level, lat, lng, place_id});
    });
  }

  setMapOnAll(map)
}

export { initMap, setMapOnAll, deleteMarkers, addMarker, map, markers}
