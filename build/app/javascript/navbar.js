document.querySelectorAll(".profile-svg").forEach(function(el) {
    el.addEventListener("click", function() {
        const profileMenu = document.getElementById("profile-menu");
        const currentDisplay = window.getComputedStyle(profileMenu).display;

        if (currentDisplay === "none") {
            profileMenu.style.display = "flex";
        } else {
            profileMenu.style.display = "none";
        }
    });
});

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]
  

  fetchResults() {
    console.log("Stimulus is working!")
    const query = this.inputTarget.value.trim()
    if (query.length < 2) {
      this.resultsTarget.style.display = "none"
      return
    }

    fetch(`/search/tmdb?q=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(data => {
        if (data.length === 0) {
          this.resultsTarget.innerHTML = "<div class='p-2 text-muted'>Nessun risultato</div>"
        } else {
          this.resultsTarget.innerHTML = data.map(item => `
            <a href="/films/${item.tmdb_id}" class="d-flex align-items-center p-2 text-decoration-none text-dark hover-bg">
              <img src="${item.poster_url}" alt="" style="width: 40px; height: 60px; object-fit: cover;" class="me-2">
              <div>
                <div><strong>${item.title}</strong></div>
                <div class="text-muted small">Film, ${item.year}</div>
              </div>
            </a>
          `).join("")
        }

        this.resultsTarget.style.display = "block"
      })
  }
}