function toggleSubMenu(event) {
    event.stopPropagation();
    var submenu = document.getElementById("submenu");
    var icon = document.getElementById("icon");

    if (submenu.style.display === "none" || submenu.style.display === "") {
        submenu.style.display = "flex";
        icon.classList.add("rotate-down");
    } else {
        submenu.style.display = "none";
        icon.classList.remove("rotate-down");
    }
}