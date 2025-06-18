    document.querySelectorAll(".profile-svg").addEventListener("click", function() {
        document.getElementById("profile-menu").style.display = "flex";
    });

    document.getElementById("close-popup").addEventListener("click", function() {
        document.getElementById("profile-menu").style.display = "none";
    });
