document.addEventListener('turbo:load', () => {
  document.querySelectorAll('.netflix-slider').forEach(slider => {
    const track = slider.querySelector('.slider-track');
    const btnLeft = slider.querySelector('.slider-btn.left');
    const btnRight = slider.querySelector('.slider-btn.right');

    if (track && btnLeft && btnRight) {
      btnRight.addEventListener('click', () => {
        track.scrollBy({ left: 220, behavior: 'smooth' });
      });

      btnLeft.addEventListener('click', () => {
        track.scrollBy({ left: -220, behavior: 'smooth' });
      });
    }
  });
});
