// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import "@hotwired/turbo-rails"
import "controllers"
import "slider"
import * as bootstrap from "bootstrap"

// home.js
document.addEventListener("turbo:load", function () {
  new Swiper(".trend-swiper", {
    slidesPerView: 1,
    spaceBetween: 20,
    loop: true,
    autoplay: {
      delay: 3000,
      disableOnInteraction: false
    },
    breakpoints: {
      640: {
        slidesPerView: 2
      },
      1024: {
        slidesPerView: 3
      },
      1280: {
        slidesPerView: 4
      }
    }
  });
});

// Popup Auth Toggle
const authPopupOverlay = document.getElementById("auth-popup-overlay");
const popupButtons = document.querySelectorAll(".popup-button.auth-button");
const closePopupButtons = document.querySelectorAll(".close-popup");

// Tab switch login/register
const tabLoginElems = document.querySelectorAll(".login-button");
const tabRegisterElems = document.querySelectorAll(".register-button");

function showLoginTab() {
  document.querySelectorAll("#login-form-popup").forEach(f => f.style.display = "block");
  document.querySelectorAll("#login-form-page").forEach(f => f.style.display = "block");
  document.querySelectorAll("#register-form-popup").forEach(f => f.style.display = "none");
  document.querySelectorAll("#register-form-page").forEach(f => f.style.display = "none");
  tabLoginElems.forEach(t => {
    t.classList.add("active-tab");
    t.classList.remove("inactive-tab");
  });
  tabRegisterElems.forEach(t => {
    t.classList.remove("active-tab");
    t.classList.add("inactive-tab");
  });
}

function showRegisterTab() {
  document.querySelectorAll("#login-form-popup").forEach(f => f.style.display = "none");
  document.querySelectorAll("#login-form-page").forEach(f => f.style.display = "none");
  document.querySelectorAll("#register-form-popup").forEach(f => f.style.display = "block");
  document.querySelectorAll("#register-form-page").forEach(f => f.style.display = "block");
  tabRegisterElems.forEach(t => {
    t.classList.add("active-tab");
    t.classList.remove("inactive-tab");
  });
  tabLoginElems.forEach(t => {
    t.classList.remove("active-tab");
    t.classList.add("inactive-tab");
  });
}

popupButtons.forEach(button => {
  button.addEventListener("click", () => {
    if (button.classList.contains("sign-up")) {
      showRegisterTab();
    } else {
      showLoginTab();
    }
    authPopupOverlay.style.display = "flex";
  });
});

closePopupButtons.forEach(button => {
  button.addEventListener("click", () => {
    authPopupOverlay.style.display = "none";
  });
});


tabLoginElems.forEach(tab =>
  tab.addEventListener("click", showLoginTab)
);
tabRegisterElems.forEach(tab =>
  tab.addEventListener("click", showRegisterTab)
);

// Register
document.querySelectorAll("#register-form-popup, #register-form-page").forEach(form => {
  form.addEventListener("submit", function (e) {
    e.preventDefault();

    const form = e.target;
    const formData = new FormData(form);
    const data = Object.fromEntries(formData.entries());

    fetch("/register", {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ user: data })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        window.location.href = data.redirect_url;
      } else {
        alert("Errore: " + data.errors.join(", "));
      }
    })
    .catch(error => {
      console.error("Errore durante la registrazione:", error);
      alert("Errore imprevisto.");
    });
  });
});


// Login
document.querySelectorAll('#login-form-popup', '#login-form-page').forEach(form => {
  form.addEventListener("submit", function (e) {
    e.preventDefault();

    const formData = new FormData(e.target);
    const data = {
      email: formData.get("email"),
      password: formData.get("password")
    }
    fetch("/login", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      },
      body: JSON.stringify(data)
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        window.location.href = data.redirect_url;
      } else {
        alert(data.error || "Email o password errati.");
      }
    })
    .catch(error => {
      console.error("Errore durante il login:", error);
      alert("Errore di rete.");
    });
  });
});

//Logout
document.querySelector("#logout-button").addEventListener("click", function (e) {
  e.preventDefault();

  fetch("/logout", {
    method: "DELETE",
    headers: {
      "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
      "Accept": "application/json"
    }
  })
  .then(response => {
    if (response.ok) {
      window.location.href = "/";
    } else {
      return response.json().then(data => {
        alert("Errore durante il logout: " + (data.error || "Errore generico"));
      });
    }
  })
  .catch(error => {
    console.error("Errore di rete durante il logout:", error);
    alert("Errore di rete.");
  });
});

// Redirezione a Movies/:id
document.querySelectorAll('.trend-card').forEach(card => {
  card.addEventListener('click', function(e) {
    const movieId = this.dataset.movieId;

    if (window.userSignedIn) {
      window.location.href = `/movies/${movieId}`;
    } else {
      e.preventDefault();
      alert('Non hai fatto l\'accesso');
    }
  });
});


