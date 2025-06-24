document.addEventListener("turbo:load", () => {
  const searchInput = document.querySelector(".search_bar");
  const resultsContainer = document.getElementById("search-results");
  const placeholder = document.getElementById("search-placeholder");
  const overlay = document.getElementById("search-overlay");
  const container = document.querySelector(".search_container");
  let timeout = null;

  function openDropdown() {
    resultsContainer.style.display = "block";
    overlay.style.display = "block";
    container.classList.add("focused");

    const query = searchInput.value.trim();
    if (query.length < 2) {
      resultsContainer.innerHTML = '<div id="search-placeholder" class="ms-2 mb-1 text-muted"><b>Nessun risultato</b></div>';
    }
  }

  function closeDropdown() {
    resultsContainer.style.display = "none";
    overlay.style.display = "none";
    container.classList.remove("focused");
  }

  searchInput.addEventListener("focus", () => {
    openDropdown();
  });

  searchInput.addEventListener("input", () => {
    const query = searchInput.value.trim();
    clearTimeout(timeout);

    if (query.length < 2) {
      resultsContainer.innerHTML = '<div id="search-placeholder" class="ms-2 mb-1 text-muted"><b>Nessun risultato</b></div>';
      return;
    }

    timeout = setTimeout(() => {
      fetch(`/tmdb_search?q=${encodeURIComponent(query)}`)
        .then(response => response.text())
        .then(html => {
          resultsContainer.innerHTML = html;
        });
    }, 300);
  });

  overlay.addEventListener("click", () => {
    closeDropdown();
  });
});
