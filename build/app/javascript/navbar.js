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