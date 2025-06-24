/*javascript for popup menu on navbar*/
/*hamburger menu*/
document.addEventListener("turbo:load", () => {
  const hamburgerTrigger = document.getElementById("hamburgerMenuTrigger");
  const hamburgerMenu = document.getElementById("hamburgerMenu");

  hamburgerTrigger.addEventListener("mouseenter", () => {
    hamburgerMenu.style.display = "block";
  });

  hamburgerMenu.addEventListener("mouseleave", () => {
    hamburgerMenu.style.display = "none";
  });

  hamburgerTrigger.addEventListener("mouseleave", () => {
    setTimeout(() => {
      if (!hamburgerMenu.matches(':hover')) {
        hamburgerMenu.style.display = "none";
      }
    }, 200);
  });
});

/*user menu*/ 
document.addEventListener("turbo:load", () =>{
  const userTrigger = document.getElementById("userMenu-Trigger");
  const userMenu = document.getElementById("user-menu");

  userTrigger.addEventListener("mouseenter", () =>{
    userMenu.style.display = "block";
  });

  userMenu.addEventListener("mouseleave", () => {
    userMenu.style.display = "none";
  });

  userTrigger.addEventListener("mouseleave", () => {
    setTimeout(() => {
      if (!userMenu.matches(':hover')) {
        userMenu.style.display = "none";
      }
    }, 200);
  });
});