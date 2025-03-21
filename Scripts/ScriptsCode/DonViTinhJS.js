// Kiểm tra trạng thái của submenu khi tải trang
window.onload = function (event) {
    event.stopPropagation();
    var submenu = document.getElementById("submenu");
    var icon = document.getElementById("icon");

    // Kiểm tra nếu trạng thái submenu đã được lưu trong localStorage
    if (localStorage.getItem("submenuOpen") === "true") {
        submenu.style.display = "flex";  // Giữ submenu mở
        icon.classList.add("rotate-down");  // Quay icon xuống dưới
    } else {
        submenu.style.display = "none";  // Giữ submenu đóng nếu không có lưu trạng thái mở
        icon.classList.remove("rotate-down");
    }
};

// Hàm mở/đóng submenu và lưu trạng thái vào localStorage
function toggleSubMenu() {

    var submenu = document.getElementById("submenu");
    var icon = document.getElementById("icon");

    // Kiểm tra trạng thái hiện tại và thay đổi trạng thái
    if (submenu.style.display === "none" || submenu.style.display === "") {
        submenu.style.display = "flex";  // Mở submenu
        icon.classList.add("rotate-down");  // Quay icon xuống dưới
        localStorage.setItem("submenuOpen", "true");  // Lưu trạng thái mở submenu
    } else {
        submenu.style.display = "none";  // Đóng submenu
        icon.classList.remove("rotate-down");  // Quay lại icon ban đầu
        localStorage.setItem("submenuOpen", "false");  // Lưu trạng thái đóng submenu
    }
}