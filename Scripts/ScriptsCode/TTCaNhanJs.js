window.onload = function (event) {
    event.stopPropagation();
    var submenu = document.getElementById("submenu");
    var icon = document.getElementById("icon");

    if (localStorage.getItem("submenuOpen") === "true") {
        submenu.style.display = "flex";
        icon.classList.add("rotate-down");
    } else {
        submenu.style.display = "none";
        icon.classList.remove("rotate-down");
    }
};

function toggleSubMenu() {
    var submenu = document.getElementById("submenu");
    var icon = document.getElementById("icon");

    if (submenu.style.display === "none" || submenu.style.display === "") {
        submenu.style.display = "flex";
        icon.classList.add("rotate-down");
        localStorage.setItem("submenuOpen", "true");
    } else {
        submenu.style.display = "none";
        icon.classList.remove("rotate-down");
        localStorage.setItem("submenuOpen", "false");
    }
}

function showModal() {
    document.getElementById("resetPasswordModal").style.display = "block";
    document.body.classList.add("modal-open");
}

function hideModal() {
    document.getElementById("resetPasswordModal").style.display = "none";
    document.body.classList.remove("modal-open");
}