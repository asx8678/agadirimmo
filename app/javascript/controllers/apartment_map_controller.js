import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="apartment-map"
export default class extends Controller {
  static values = { latitude: Number, longitude: Number }

  connect() {
    if (typeof L === 'undefined') {
      console.error("Leaflet is not loaded");
      return;
    }

    // Initialize the mini map
    this.map = L.map(this.element, {
      scrollWheelZoom: false,
      dragging: false,
      touchZoom: false,
      doubleClickZoom: false,
      boxZoom: false,
      keyboard: false,
      zoomControl: false
    });

    // Add light tile layer to match the theme
    L.tileLayer('https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png', {
      maxZoom: 19,
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>'
    }).addTo(this.map);

    // Set view and add marker
    const lat = this.latitudeValue || 0;
    const lng = this.longitudeValue || 0;
    
    this.map.setView([lat, lng], 14);
    
    // Custom marker icon for light theme
    const customIcon = L.divIcon({
      className: 'custom-marker',
      html: '<div style="background: #000000; width: 18px; height: 18px; border-radius: 50%; border: 2px solid white; box-shadow: 0 2px 8px rgba(0,0,0,0.3);"></div>',
      iconSize: [18, 18],
      iconAnchor: [9, 9]
    });
    
    L.marker([lat, lng], { icon: customIcon }).addTo(this.map);

    // Ensure map renders properly
    setTimeout(() => {
      this.map.invalidateSize();
    }, 100);
  }

  disconnect() {
    if (this.map) {
      this.map.remove();
    }
  }
}