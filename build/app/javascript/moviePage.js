if(document.getElementById("map")){
  function initMap() {
    const defaultPosition = {lat: 41.903870, lng: 12.513220};
    const map = new google.maps.Map(document.getElementById("map"), {
      zoom: 12,
      center: defaultPosition,
    });
    
    const cinemas = window.cinemas || [];
    const bounds = new google.maps.LatLngBounds();
    
    const markers = [];
    
    cinemas.forEach((cinema) => {
      if (cinema.lat && cinema.lng) {
        const position = new google.maps.LatLng(cinema.lat, cinema.lng);
        bounds.extend(position);
        
        const marker = new google.maps.Marker({
          position: position,
          map: map,
          title: cinema.name,
          animation: google.maps.Animation.DROP
        });
        
        markers.push(marker);
        
        const contentString = `
          <div class="p-2 min-w-[200px]">
            <h3 class="font-bold text-lg">${cinema.name}</h3>
            <p class="text-sm text-gray-600">${cinema.address}</p>
            <p class="text-xs mt-2 font-semibold">Orari:</p>
            <div class="flex flex-wrap gap-1 mt-1">
              ${cinema.showing.split(', ').map(time => 
                `<span class="bg-blue-100 text-blue-800 px-2 py-1 rounded text-xs">${time}</span>`
              ).join('')}
            </div>
          </div>
        `;
        
        const infoWindow = new google.maps.InfoWindow({ content: contentString });
        
        marker.addListener("click", () => {
          markers.forEach(m => {
            if (m.infoWindow) m.infoWindow.close();
          });
          
          infoWindow.open(map, marker);
          marker.infoWindow = infoWindow;
          
          map.panTo(marker.getPosition());
        });
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
      item.addEventListener('click', function() {
        const cinemaId = this.dataset.id;
        const cinema = cinemas.find(c => c.id == cinemaId);
        
        if (cinema && cinema.lat && cinema.lng) {
          const position = new google.maps.LatLng(cinema.lat, cinema.lng);
          map.panTo(position);
          map.setZoom(15);
          
          const marker = markers.find(m => m.title === cinema.name);
          if (marker && marker.infoWindow) {
            markers.forEach(m => {
              if (m.infoWindow && m !== marker) m.infoWindow.close();
            });
            
            marker.infoWindow.open(map, marker);
          }
        }
      });
    });
  }

  window.initMap = initMap;
};