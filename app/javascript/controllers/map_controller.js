import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
export default class extends Controller {
  static targets = ["map", "list", "toggleButton"]

  connect() {
    // Ensure the map container target exists before initializing Leaflet
    if (!this.hasMapTarget || !this.mapTarget) {
      console.error("Map container not found. Ensure the index view includes an element with data-map-target=\"map\".");
      return;
    }

    // Initialize the map
    this.map = L.map(this.mapTarget, {
      scrollWheelZoom: true
    });

    // Default view: Agadir, Morocco
    // Previously Warsaw: [52.2297, 21.0122], 12
    this.map.setView([30.4275, -9.5980], 12);

    // Use light theme tiles to match the UI
    if (!this.tileLayer) {
      this.tileLayer = L.tileLayer("https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png", {
        maxZoom: 19,
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>'
      }).addTo(this.map);
    }

    // Initial fetch once map is ready, then on moveend
    const doInitialFetch = () => {
      this.fetchApartmentsForBounds().catch((e) => console.error("Initial fetch failed:", e));
      this.map.off("load", doInitialFetch);
    };
    this.map.on("load", doInitialFetch);
    // If load already fired (some browsers), call fetch directly
    if ((this.map._loaded || false) === true) {
      this.fetchApartmentsForBounds().catch((e) => console.error("Immediate fetch failed:", e));
    }

    this.map.on("moveend", () => {
      this.fetchApartmentsForBounds().catch((e) => console.error("Moveend fetch failed:", e));
    });

    // Defensive checks for targets
    if (!this.hasListTarget) {
      console.warn("map_controller: listTarget missing; list panel will not render.");
    }
    if (!this.hasToggleButtonTarget) {
      console.warn("map_controller: toggleButtonTarget missing; toggle may not work.");
    }
  }

  toggle() {
    if (!this.hasListTarget) return
    this.listTarget.classList.toggle("hidden")
    // Trigger map resize so tiles reposition after layout change
    setTimeout(() => this.map.invalidateSize(), 200)
  }

  async fetchApartmentsForBounds() {
    if (!this.map) return;
    const bounds = this.map.getBounds();
    const params = new URLSearchParams({
      north: bounds.getNorth().toString(),
      south: bounds.getSouth().toString(),
      east: bounds.getEast().toString(),
      west: bounds.getWest().toString(),
    });

    const res = await fetch(`/apartments.json?${params.toString()}`);
    if (!res.ok) {
      console.error("Failed to fetch apartments:", res.status, res.statusText);
      return;
    }
    const data = await res.json();
    this.renderMarkersAndList(data);
  }

  renderMarkersAndList(apartments) {
    // Clear existing markers layer
    if (this.markersLayer) {
      this.map.removeLayer(this.markersLayer);
    }
    this.markersLayer = L.layerGroup().addTo(this.map);

    // Render markers with custom styling for dark theme
    apartments.forEach((apt) => {
      if (apt.latitude == null || apt.longitude == null) return;
      
      // Custom marker icon for light theme
      const customIcon = L.divIcon({
        className: 'custom-apartment-marker',
        html: `<div style="
          background: #000000; 
          width: 20px; 
          height: 20px; 
          border-radius: 50%; 
          border: 2px solid white; 
          box-shadow: 0 2px 8px rgba(0,0,0,0.3);
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 10px;
          font-weight: bold;
          color: white;
        "></div>`,
        iconSize: [20, 20],
        iconAnchor: [10, 10]
      });
      
      const marker = L.marker([apt.latitude, apt.longitude], { icon: customIcon }).addTo(this.markersLayer);
      const price = apt.price_cents != null ? (apt.price_cents / 100.0).toFixed(2) : "";
      const popupHtml = `
        <div class="marker-popup" style="text-align: center; padding: 8px;">
          <strong style="color: #333333; font-size: 14px;">${this.escapeHtml(apt.title || "Apartment")}</strong><br/>
          ${price ? `<span style="color: #05a05e; font-weight: 600;">$${price}</span><br/>` : ""}
          <span style="color: #666666;">${this.escapeHtml(apt.city || "")}</span>
        </div>
      `;
      marker.bindPopup(popupHtml);
      
      // Add click handler to navigate to apartment details
      marker.on('click', () => {
        if (apt.id) {
          window.location.href = `/apartments/${apt.id}`;
        }
      });
    });

    // Render list panel if present
    if (this.hasListTarget) {
      const ul = this.listTarget.querySelector("ul.apartments-list") || this.listTarget;
      // Clear list
      while (ul.firstChild) ul.removeChild(ul.firstChild);

      apartments.forEach((apt) => {
        const li = document.createElement("li");
        li.className = "apartment-item";
        const price = apt.price_cents != null ? (apt.price_cents / 100.0).toFixed(2) : "";
        li.innerHTML = `
          <h4>${this.escapeHtml(apt.title || "Apartment")}</h4>
          <div class="meta">
            <span>${this.escapeHtml(apt.city || "")}</span>
            ${price ? `<span style="color: #05a05e; font-weight: 600;">$${price}</span>` : ""}
          </div>
        `;
        li.addEventListener("click", () => {
          if (apt.latitude != null && apt.longitude != null) {
            this.map.setView([apt.latitude, apt.longitude], 16);
            // Highlight the corresponding marker
            this.highlightMarkerForApartment(apt.id);
          }
        });
        ul.appendChild(li);
      });
    }
  }

  highlightMarkerForApartment(apartmentId) {
    // This could be enhanced to actually highlight the specific marker
    // For now, we just focus on the map area
    console.log(`Highlighting apartment ${apartmentId}`);
  }

  escapeHtml(s) {
    if (s == null) return "";
    return String(s)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;");
  }
}
