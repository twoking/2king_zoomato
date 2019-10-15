import mapboxgl from "mapbox-gl";

const error = err => {
	console.warn(`ERROR(${err.code}): ${err.message}`);
};

const options = {
	enableHighAccuracy: false,
	timeout: 5000,
	maximumAge: 0
};

// const getUserCoordinates = () => {
//   navigator.geolocation.watchPosition(success, error, options);
// }

const getUserCoordinates = () => {
	if (navigator.geolocation) {
		return new Promise(resolve => {
			navigator.geolocation.getCurrentPosition(function(position) {
				resolve([position.coords.longitude, position.coords.latitude]);
			});
		});
	}
};

const success = location => {
	return initMapbox([location.coords.longitude, location.coords.latitude]);
};

const initMapbox = async () => {
	let mapElement;
	let mapCenter = await getUserCoordinates();
	const mapContainer = document.getElementById("map");
	if (mapContainer) {
		// only build a map if there's a div#map to inject into
		mapboxgl.accessToken = mapContainer.dataset.mapboxApiKey;
		mapElement = new mapboxgl.Map({
			center: mapCenter,
			container: "map",
			zoom: 15,
			style: "mapbox://styles/mapbox/streets-v10"
		});
	}
	return mapElement;
};

const loadMap = new Promise(resolve => {
	resolve(initMapbox());
});

export { loadMap };
