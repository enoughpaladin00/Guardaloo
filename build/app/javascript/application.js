// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import "@hotwired/turbo-rails"
import "controllers"
import "slider"
import * as bootstrap from "bootstrap"
import "index"
import "moviePage"

document.addEventListener("turbo:load", function () {
  const swiperContainer = document.querySelector(".trend-swiper");
  const slides = swiperContainer?.querySelectorAll(".swiper-slide") || [];

  if (!swiperContainer || slides.length === 0) return;

  if (window.trendSwiper && window.trendSwiper.destroy) {
    window.trendSwiper.destroy(true, true);
  }

  window.trendSwiper = new window.Swiper(".trend-swiper", {
    loop: true,
    slidesPerView: 1,
    spaceBetween: 20,
    autoplay: {
      delay: 3000,
      disableOnInteraction: false
    },
    breakpoints: {
      640: { slidesPerView: 2 },
      1024: { slidesPerView: 3 },
      1280: { slidesPerView: 4 }
    }
  });
});
