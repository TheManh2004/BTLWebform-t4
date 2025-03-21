document.addEventListener('DOMContentLoaded', function () {
    // Toggle submenu in sidebar
    function toggleSubMenu(event) {
        var submenu = document.getElementById('submenu');
        var icon = document.getElementById('icon');
        submenu.style.display = submenu.style.display === 'none' || submenu.style.display === '' ? 'flex' : 'none';
        icon.classList.toggle('rotate-down');
    }

    // Show Add Table Modal
    function showAddTableModal(floor) {
        console.log("Showing table modal for floor: " + floor);
        if (!floor) floor = "1";
        var modal = document.getElementById('addTableModal');
        if (modal) {
            modal.style.display = 'flex';
            document.getElementById('txtFloor').value = 'Tầng ' + floor;
            document.getElementById('hdnFloor').value = floor;
        } else {
            console.error("Add Table Modal element not found!");
        }
    }

    // Show Add Area Modal
    function showAddAreaModal() {
        console.log("Showing area modal");
        var modal = document.getElementById('addAreaModal');
        if (modal) {
            modal.style.display = 'flex';
            document.getElementById('txtNewFloorName').value = ''; // Clear input
        } else {
            console.error("Add Area Modal element not found!");
        }
    }

    // Close Modal (generic for both modals)
    function closeModal(modalId) {
        var modal = document.getElementById(modalId);
        if (modal) {
            modal.style.display = 'none';
            if (modalId === 'addTableModal') {
                document.getElementById('txtTableName').value = '';
            } else if (modalId === 'addAreaModal') {
                document.getElementById('txtNewFloorName').value = '';
            }
        }
    }

    // Expose functions to global scope
    window.showAddTableModal = showAddTableModal;
    window.showAddAreaModal = showAddAreaModal;
    window.closeModal = closeModal;
    window.toggleSubMenu = toggleSubMenu;
});
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