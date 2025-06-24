document.querySelectorAll(".profile-svg").forEach(function(el) {
    el.addEventListener("click", function() {
        const profileMenu = document.getElementById("profile-menu");
        const currentDisplay = window.getComputedStyle(profileMenu).display;

        if (currentDisplay === "none") {
            profileMenu.style.display = "flex";
        } else {
            profileMenu.style.display = "none";
        }
    });
});

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
