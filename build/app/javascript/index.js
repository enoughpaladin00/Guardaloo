document.addEventListener("turbo:load", function () {
  const gliderEl = document.querySelector(".glider");
  if (!gliderEl) return;

  const glider = new Glider(gliderEl, {
    slidesToShow: 1,
    slidesToScroll: 1,
    draggable: true,
    dots: ".dots",
    responsive: [
      {
        breakpoint: 640,
        settings: {
          slidesToShow: 3,
          dots: '.dots',
        }
      },
      {
        breakpoint: 1024,
        settings: {
          slidesToShow: 4,
          dots: '.dots',
        }
      },
      {
        breakpoint: 1280,
        settings: {
          slidesToShow: 6,
          dots: '.dots',
        }
      },
      {
        breakpoint: 0,
        settings: {
          dots: '',
        }
      }
    ]
  });

  const totalSlides = gliderEl.querySelectorAll(".glider-slide").length;

  let slideIndex = 0;

  function getCurrentSlidesToShow() {
    const width = window.innerWidth;
    if (width >= 1280) return 6;
    if (width >= 1024) return 4;
    if (width >= 640) return 3;
    return 1;
  }

  setInterval(() => {
    const slidesToShow = getCurrentSlidesToShow();

    slideIndex += slidesToShow;

    if (slideIndex > totalSlides) {
      slideIndex = 0;
    }

    glider.scrollItem(slideIndex);
  }, 6000);
});



// === Popup Auth Toggle ===
const authPopupOverlay = document.getElementById("auth-popup-overlay");
const popupButtons = document.querySelectorAll(".popup-button.auth-button");
const closePopupButtons = document.querySelectorAll(".close-popup");

// === Tab switch login/register ===
const tabLoginElems = document.querySelectorAll(".login-button");
const tabRegisterElems = document.querySelectorAll(".register-button");

function showLoginTab() {
  document.querySelectorAll("#login-form-popup").forEach(f => f.style.display = "block");
  document.querySelectorAll("#register-form-popup").forEach(f => f.style.display = "none");
  document.querySelectorAll(".form-error").forEach(el => {
    el.style.display = "none";
    el.innerText = "";
  });
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
  document.querySelectorAll("#register-form-popup").forEach(f => f.style.display = "block");
  document.querySelectorAll(".form-error").forEach(el => {
    el.style.display = "none";
    el.innerText = "";
  });
  tabRegisterElems.forEach(t => {
    t.classList.add("active-tab");
    t.classList.remove("inactive-tab");
  });
  tabLoginElems.forEach(t => {
    t.classList.remove("active-tab");
    t.classList.add("inactive-tab");
  });
}

// === Popup open/close ===
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
    document.querySelectorAll(".form-error").forEach(el => {
      el.style.display = "none";
      el.innerText = "";
    });
  });
});

tabLoginElems.forEach(tab => tab.addEventListener("click", showLoginTab));
tabRegisterElems.forEach(tab => tab.addEventListener("click", showRegisterTab));

// === Redirect su click film ===
document.querySelectorAll('.trend-card').forEach(card => {
  card.addEventListener('click', function(e) {
    const movieId = this.dataset.movieId;
    window.location.href = `/movies/${movieId}`;
  });
});

// === Logout ===
if (document.querySelector("#logout-button")) {
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
}
