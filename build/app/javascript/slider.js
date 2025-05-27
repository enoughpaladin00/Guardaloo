document.addEventListener('turbo:load', () => {
  document.querySelectorAll('.netflix-slider').forEach(slider => {
    const track = slider.querySelector('.slider-track');
    const btnLeft = slider.querySelector('.slider-btn.left');
    const btnRight = slider.querySelector('.slider-btn.right');

    if (!track || !btnLeft || !btnRight) return;

    const updateButtons = () => {
      const scrollLeft = track.scrollLeft;
      const maxScroll = track.scrollWidth - track.clientWidth;

      btnLeft.style.display = scrollLeft > 0 ? 'block' : 'none';

      btnRight.style.display = scrollLeft < maxScroll ? 'block' : 'none';
    };

    track.addEventListener('scroll', updateButtons);
    window.addEventListener('resize', updateButtons);
    updateButtons();

    
    btnRight.addEventListener('click', () => {
      track.scrollBy({ left: 1000, behavior: 'smooth' });
    });
    btnLeft.addEventListener('click', () => {
      track.scrollBy({ left: -1000, behavior: 'smooth' });
    });
    

    
  });
});
