function initMap() {
  const defaultPosition = { lat: 41.903870, lng: 12.513220 };
  const map = new google.maps.Map(document.getElementById("map"), {
    zoom: 12,
    center: defaultPosition,
    mapId:  '<%= @map_id %>',
  });

  const cinemas = window.cinemas || [];
  const bounds = new google.maps.LatLngBounds();
  const markers = [];
  const infoWindow = new google.maps.InfoWindow();

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      (position) => {
        const userPos = {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        };

        console.log(userPos);
        const userMarker = new google.maps.marker.AdvancedMarkerElement({
          position: userPos,
          map: map,
          title: "Sei qui",
          content: createCustomIcon("#4285F4")
        });

        bounds.extend(userPos);
        map.setCenter(userPos);
      },
      () => {
        console.warn("Geolocalizzazione negata. Uso posizione predefinita.");
      }
    );
  } else {
    console.warn("Geolocalizzazione non supportata dal browser.");
  }


  cinemas.forEach((cinema) => {
    if (cinema.lat && cinema.lng) {
      const position = new google.maps.LatLng(cinema.lat, cinema.lng);
      bounds.extend(position);

      const marker = new google.maps.marker.AdvancedMarkerElement({
        position: position,
        map: map,
        title: cinema.name
      });

      markers.push(marker);

      const contentString = `
        <div class="p-2 min-w-[200px]">
          <h3 class="font-bold text-lg">${cinema.name}</h3>
          <p class="text-sm text-gray-600">${cinema.address || ''}</p>
          <p class="text-xs mt-2 font-semibold">Orari:</p>
          <div class="flex flex-wrap gap-1 mt-1">
            ${cinema.showing 
              ? cinema.showing.split(', ').map(time => 
                  `<span class="bg-blue-100 text-blue-800 px-2 py-1 rounded text-xs">${time}</span>`
                ).join('') 
              : '<span class="text-xs text-gray-400">Nessun orario disponibile</span>'
            }
          </div>
        </div>
      `;

      marker.addListener("click", () => {
        infoWindow.setContent(contentString);
        infoWindow.open(map, marker);
        map.panTo(marker.position);
      });
    } else {
      console.log("Cinema con lat/lng null:", cinema.name);
    }
  });

  if (!bounds.isEmpty()) {
    map.fitBounds(bounds);
    const zoom = map.getZoom();
    if (zoom > 14) {
      map.setZoom(14);
    }
  }

  document.querySelectorAll('.cinema-item').forEach(item => {
    item.addEventListener('click', function () {
      const cinemaId = Number(this.dataset.id);
      const cinema = cinemas.find(c => c.id === cinemaId);

      if (cinema && cinema.lat && cinema.lng) {
        const position = new google.maps.LatLng(cinema.lat, cinema.lng);
        map.panTo(position);
        map.setZoom(15);

        const marker = markers.find(m => m.title === cinema.name);
        if (marker) {
          const contentString = `
            <div class="p-2 min-w-[200px]">
              <h3 class="font-bold text-lg">${cinema.name}</h3>
              <p class="text-sm text-gray-600">${cinema.address || ''}</p>
              <p class="text-xs mt-2 font-semibold">Orari:</p>
              <div class="flex flex-wrap gap-1 mt-1">
                ${cinema.showing 
                  ? cinema.showing.split(', ').map(time => 
                      `<span class="bg-blue-100 text-blue-800 px-2 py-1 rounded text-xs">${time}</span>`
                    ).join('') 
                  : '<span class="text-xs text-gray-400">Nessun orario disponibile</span>'
                }
              </div>
            </div>
          `;
          infoWindow.setContent(contentString);
          infoWindow.open(map, marker);
        }
      }
    });
  });
}

function createCustomIcon(color) {
  const div = document.createElement('div');
  div.style.width = '16px';
  div.style.height = '16px';
  div.style.borderRadius = '50%';
  div.style.backgroundColor = color;
  div.style.border = '2px solid white';
  return div;
}

if (document.getElementById("map")) {
  window.initMap = initMap;
}


// Visualizzazione Programmazione by day
document.addEventListener("turbo:load", function () {
  const buttons = document.querySelectorAll(".tab-button");
  const cinemaLists = document.querySelectorAll(".cinema-list-day");
  buttons.forEach(button => {
    button.addEventListener("click", () => {
      const selectedDay = button.getAttribute("data-day");

      buttons.forEach(btn => btn.classList.remove("active", "bg-blue-500", "text-white"));
      button.classList.add("active", "bg-blue-500", "text-white");

      cinemaLists.forEach(list => {
        if (list.getAttribute("data-day") === selectedDay) {
          list.style.display = "block";
        } else {
          list.style.display = "none";
        }
      });
    });
  });
});