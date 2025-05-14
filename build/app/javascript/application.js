// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"
import Swiper from 'https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.mjs'


// home
document.addEventListener("DOMContentLoaded", function () {
    new Swiper(".mySwiper", {
        slidesPerView: 1,
        spaceBetween: 20,
        loop: true,
        breakpoints: {
            768: {
                slidesPerView: 2,
            },
            1024: {
                slidesPerView: 3,
            },
        }
    });

    new Swiper(".mySwiper2", {
        slidesPerView: 2,
        spaceBetween: 20,
        loop: true,
        breakpoints: {
            768: {
                slidesPerView: 3,
            },
            1024: {
                slidesPerView: 5,
            },
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
  document.querySelectorAll("#register-form-popup").forEach(f => f.style.display = "none");
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