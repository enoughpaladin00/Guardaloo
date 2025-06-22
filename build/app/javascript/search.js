document.addEventListener("DOMContentLoaded", () => {
  const searchInput = document.querySelector(".search_bar");
  const resultsContainer = document.getElementById("search-results");
  let timeout = null;

  searchInput.addEventListener("input", () => {
    const query = searchInput.value.trim();

    clearTimeout(timeout);

    if (query.length < 2) {
      resultsContainer.style.display = "none";
      resultsContainer.innerHTML = "";
      return;
    }

    timeout = setTimeout(() => {
      fetch(`/tmdb_search?q=${encodeURIComponent(query)}`)
        .then(response => response.text())
        .then(html => {
          resultsContainer.innerHTML = html;
          resultsContainer.style.display = "block";
        });
    }, 300);
  });

  document.addEventListener("click", (event) => {
    if (!resultsContainer.contains(event.target) && !searchInput.contains(event.target)) {
      resultsContainer.style.display = "none";
    }
  });
});