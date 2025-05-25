console.log("avviato");
const track = document.getElementById('track');
const btnLeft = document.querySelector('.slider-btn.left');
const btnRight = document.querySelector('.slider-btn.right');
btnRight.addEventListener('click', () => {
  track.scrollBy({ left: 220, behavior: 'smooth' });
});
btnLeft.addEventListener('click', () => {
  track.scrollBy({ left: -220, behavior: 'smooth' });
});