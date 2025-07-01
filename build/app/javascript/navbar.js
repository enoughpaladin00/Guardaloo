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

  const isMobile = window.matchMedia("(max-width: 992px)").matches;

  if (isMobile) {
    hamburgerTrigger.addEventListener("click", () => {
      const isVisible = hamburgerMenu.style.display === "block";
      hamburgerMenu.style.display = isVisible ? "none" : "block";
    });
  } else {
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
  }
});