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

    // Popup Auth Toggle
    const authPopupOverlay = document.getElementById("auth-popup-overlay");
    const popupButtons = document.querySelectorAll(".auth-button");
    const closePopupButtons = document.querySelectorAll(".close-popup");

    // Tab switch login/register
    const tabLogin = document.querySelectorAll("#tab-login-popup");
    const tabRegister = document.querySelectorAll("#tab-register-popup");

    popupButtons.forEach(button => {
        button.addEventListener("click", () => {
            authPopupOverlay.style.display = "flex";
        });
    });

    closePopupButtons.forEach(button => {
        button.addEventListener("click", () => {
            authPopupOverlay.style.display = "none";
        });
    });

    tabLogin.forEach(tab => {
        tab.addEventListener("click", () => {
            document.querySelectorAll("#login-form-popup").forEach(form => form.style.display = "block");
            document.querySelectorAll("#register-form-popup").forEach(form => form.style.display = "none");
            tabLogin.forEach(t => t.classList.add("active-tab"));
            tabLogin.forEach(t => t.classList.remove("inactive-tab"));
            tabRegister.forEach(t => t.classList.remove("active-tab"));
            tabRegister.forEach(t => t.classList.add("inactive-tab"));
        });
    });

    tabRegister.forEach(tab => {          
        tab.addEventListener("click", () => {
            document.querySelectorAll("#login-form-popup").forEach(form => form.style.display = "none");
            document.querySelectorAll("#register-form-popup").forEach(form => form.style.display = "block");
            tabRegister.forEach(t => t.classList.add("active-tab"));
            tabRegister.forEach(t => t.classList.remove("inactive-tab"));
            tabLogin.forEach(t => t.classList.remove("active-tab"));
            tabLogin.forEach( t=> t.classList.add("inactive-tab"));
        });
    });
});
