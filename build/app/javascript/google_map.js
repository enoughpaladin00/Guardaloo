function initMap() {
  const fallback = { lat: 41.9028, lng: 12.4964 }; // Roma

  const map = new google.maps.Map(document.getElementById("map_new"), {
    center: fallback,
    zoom: 13,
  });

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      function (position) {
        const userPos = {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        };

        map.setCenter(userPos);

        new google.maps.Marker({
          position: userPos,
          map: map,
          title: "Sei qui"
        });

        // Chiamata test al backend
        fetch(`/nearby_cinemas?lat=${userPos.lat}&lng=${userPos.lng}`)
          .then(r => r.json())
          .then(data => {
            data.forEach(c => {
              new google.maps.Marker({
                position: { lat: c.lat, lng: c.lng },
                map: map,
                title: c.name
              });
            });
          });
      },
      function (error) {
        console.warn("Errore nella geolocalizzazione:", error);
      },
      { timeout: 8000 }
    );
  } else {
    alert("Geolocalizzazione non supportata");
  }
}

window.initMap = initMap;
