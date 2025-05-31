//Google Maps
if(document.getElementById("map")){
  function initMap() {

    console.log("initMap chiamata correttamente");
    const defaultPosition = {lat: 41.903870,lng: 12.513220}

    function createMap(center) {
      const map = new google.maps.Map(document.getElementById("map"), {
        zoom:13,
        center:center,
      });

      const cinemas = window.cinemas || [];
      cinemas.forEach((cinema) => {
        const marker = new google.maps.Marker({
          position: { lat: cinema.lat, lng: cinema.lng },
          map: map,
          title: cinema.name
        });

        marker.addListener("click", () => {
          const url = `https://www.google.com/maps/search/?api=1&query=${cinema.lat},${cinema.lng}`;
          window.open(url, '_blank');
        });
      });
    }
    
    if (navigator.geolocation){
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const userLocation = {
            lat: position.coords.latitude,
            lng: position.coords.longitude,
          };
          createMap(userLocation);
        },
        () => {
          createMap(defaultPosition);
        }
      );
    } else {
      createMap(defaultPosition);
    }
  };

  window.initMap = initMap;
};