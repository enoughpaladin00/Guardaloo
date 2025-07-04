// NEW
document.addEventListener('turbo:load', () => {
  const input = document.getElementById('movie_title_input');
  const suggestions = document.getElementById('movie-suggestions');
  const hiddenMovieId = document.getElementById('movie_id_input');
  const hiddenPosterPath = document.getElementById('movie_poster_path_input');

  if (!input || !hiddenMovieId || !suggestions || !hiddenPosterPath) return;

  let timeout = null;

  input.addEventListener('input', () => {
    clearTimeout(timeout);
    const query = input.value.trim();

    if (query.length < 2) {
      suggestions.style.display = 'none';
      return;
    }

    timeout = setTimeout(() => {
      fetch(`/movies/search?query=${encodeURIComponent(query)}`)
        .then(response => response.json())
        .then(data => {
          suggestions.innerHTML = '';
          if (data.length > 0) {
            data.slice(0, 5).forEach(movie => {
              const item = document.createElement('div');
              item.classList.add('movie-suggestion-item');

              const poster = document.createElement('img');
              poster.src = movie.poster_path 
                ? `https://image.tmdb.org/t/p/w92${movie.poster_path}`
                : '/assets/images/post/placeholder.jpg';
              poster.alt = movie.title;
              poster.classList.add('movie-suggestion-poster');

              const text = document.createElement('span');
              const year = movie.release_date ? ` (${new Date(movie.release_date).getFullYear()})` : '';
              text.textContent = movie.title + year;

              item.appendChild(poster);
              item.appendChild(text);

              item.addEventListener('click', () => {
                input.value = movie.title;
                hiddenMovieId.value = movie.id;
                hiddenPosterPath.value = movie.poster_path;
                suggestions.style.display = 'none';


                // **AGGIORNA IMMAGINE NELLA COLONNA SINISTRA**
                const posterImg = document.getElementById('movie-poster-img');
                posterImg.classList.remove('blurred');
                if (movie.poster_path) {
                  posterImg.src = `https://image.tmdb.org/t/p/w342${movie.poster_path}`;
                } else {
                  posterImg.src = '/assets/images/post/placeholder.jpg';
                }placeholder
              });

              suggestions.appendChild(item);
            });

            suggestions.style.display = 'block';
          } else {
            suggestions.style.display = 'none';
          }
        });
    }, 300);
  });

  // Impedisce che si possa scrivere titoli di film non validi
  const form = document.querySelector('#new-post-form');
  if (form) {
    form.addEventListener('submit', (event) => {
      const movieId = hiddenMovieId.value.trim();
      if (!movieId) {
        event.preventDefault();
        alert("Seleziona un film valido dai suggerimenti.");
      }
    });
  }


  // Nascondi suggerimenti se clicchi fuori
  document.addEventListener('click', (e) => {
    if (!suggestions.contains(e.target) && e.target !== input) {
      suggestions.style.display = 'none';
    }
  });

});

// SHOW
document.addEventListener('turbo:load', () => {
  const btn = document.getElementById('show-new-comment-form');
  const formContainer = document.getElementById('new-comment-form');

  if (!btn || !formContainer) return;

  btn.addEventListener('click', () => {
    const isHidden = formContainer.style.display === 'none' || formContainer.style.display === '';

    formContainer.style.display = isHidden ? 'block' : 'none';
    btn.textContent = isHidden ? 'Annulla inserimento' : 'Commenta il post';

    // Scrolla al centro solo se il form è stato appena mostrato
    if (isHidden) {
      // Timeout necessario per assicurarsi che il form sia visibile prima di calcolare la posizione
      setTimeout(() => {
        const rect = formContainer.getBoundingClientRect();
        const offset = rect.top + window.pageYOffset - (window.innerHeight / 2) + (rect.height / 2);

        window.scrollTo({
          top: offset,
          behavior: 'smooth'
        });
      }, 100); // 100ms di attesa per sicurezza
    }
  });
});

// INDEX
document.addEventListener('turbo:load', () => {
  document.querySelectorAll('.post-card').forEach(card => {
    card.style.cursor = 'pointer';

    card.addEventListener('click', e => {
      const tag = e.target.tagName.toLowerCase();

      // ignora click su link, button, input, textarea, svg, path, form, etc.
      if (['a', 'button', 'svg', 'path', 'input', 'textarea', 'form'].includes(tag)) return;

      const link = card.querySelector('.post-title h2 a');
      if (link) {
        window.location.href = link.href;
      }
    });
  });
});

// EDIT POST
document.addEventListener("turbo:load", function() {
  const form = document.getElementById("edit-post-form");
  if (form) {
    form.addEventListener("submit", function(event) {
      const confirmed = confirm("Sei sicuro di voler modificare questo post?");
      if (!confirmed) {
        event.preventDefault(); // blocca l’invio del form
      }
    });
  }
});
