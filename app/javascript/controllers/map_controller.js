import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas", "listPanel", "toggleButton"]

  connect() {
    // Ensure Leaflet is available either via leaflet-rails assets or CDN
    // If using leaflet-rails, its JS/CSS is included via the asset pipeline.
    this.initMap()
    this.fetchAndRenderMarkers()
  }

  initMap() {
    // Create map
    this.map = L.map(this.canvasTarget, { scrollWheelZoom: true })
    // OSM tiles with attribution
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      maxZoom: 19,
      attribution:
        '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    }).addTo(this.map)

    // Initial view (Europe/Warsaw area)
    this.map.setView([52.2297, 21.0122], 12)

    // Re-fetch markers when map stops moving (bounding box filtering)
    this.map.on("moveend", () => this.fetchAndRenderMarkers())
  }

  toggle() {
    if (!this.hasListPanelTarget) return
    this.listPanelTarget.classList.toggle("hidden")
    // Trigger map resize so tiles reposition after layout change
    setTimeout(() => this.map.invalidateSize(), 200)
  }

  async fetchAndRenderMarkers() {
    if (!this.map) return
    const bounds = this.map.getBounds()
    const params = new URLSearchParams({
      north: bounds.getNorth(),
      south: bounds.getSouth(),
      east: bounds.getEast(),
      west: bounds.getWest(),
    })

    try {
      const res = await fetch(`/apartments.json?${params.toString()}`)
      if (!res.ok) throw new Error(`HTTP ${res.status}`)
      const data = await res.json()
      this.renderMarkers(data)
      this.renderList(data)
    } catch (e) {
      // eslint-disable-next-line no-console
      console.error("Failed to load apartments JSON", e)
    }
  }

  renderMarkers(apartments) {
    // Clear previous layer group if any
    if (this.markersLayer) {
      this.map.removeLayer(this.markersLayer)
    }
    this.markersLayer = L.layerGroup().addTo(this.map)

    apartments.forEach((apt) => {
      if (apt.latitude == null || apt.longitude == null) return
      const marker = L.marker([apt.latitude, apt.longitude]).addTo(this.markersLayer)
      const popup = `
        <div style="min-width: 220px">
          <strong>${this.escapeHTML(apt.title || "Apartment")}</strong><br/>
          ${apt.price_cents != null ? (apt.price_cents / 100).toFixed(0) + " PLN" : ""}<br/>
          <a href="/apartments/${apt.id}">Open details</a>
        </div>
      `
      marker.bindPopup(popup)
    })
  }

  renderList(apartments) {
    if (!this.hasListPanelTarget) return
    this.listPanelTarget.innerHTML = apartments
      .map((apt) => {
        const price = apt.price_cents != null ? `${(apt.price_cents / 100).toFixed(0)} PLN` : ""
        return `
          <div class="apt-item" data-id="${apt.id}" style="padding:8px;border-bottom:1px solid #eee;cursor:pointer">
            <div style="font-weight:600">${this.escapeHTML(apt.title || "Apartment")}</div>
            <div style="color:#555">${price}</div>
            <div style="color:#777;font-size:12px">${this.escapeHTML(apt.city || "")}</div>
          </div>
        `
      })
      .join("")

    // Add click handlers to recent list
    this.listPanelTarget.querySelectorAll(".apt-item").forEach((el) => {
      el.addEventListener("click", () => {
        const id = el.getAttribute("data-id")
        // Center on marker by fetching show JSON quickly for coordinates or reuse known coords
        // For now, just navigate to details
        window.location.href = `/apartments/${id}`
      })
    })
  }

  escapeHTML(str) {
    return (str || "").replace(/[&<>"']/g, (m) => {
      switch (m) {
        case "&": return "&amp;"
        case "<": return "&lt;"
        case ">": return "&gt;"
        case '"': return "&quot;"
        case "'": return "&#39;"
      }
      return m
    })
  }
}
