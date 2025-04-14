// Hàm được gọi khi click nút chọn tầng
function selectFloor(floorId, floorName) {
    document.getElementById('hdnCurrentFloor').value = floorName;
    document.getElementById('hdnAreaId').value = floorId; // Cập nhật idArea
    let buttons = document.querySelectorAll('.btn-floor');
    buttons.forEach(btn => btn.classList.remove('active'));
    event.target.classList.add('active');
}

// Hiển thị modal thêm bàn
function showAddTableModal(floorName, floorId) {
    // Gán giá trị floorName và floorId vào các trường
    document.getElementById('txtFloor').value = floorName;
    document.getElementById('hdnAreaId').value = floorId; // Cập nhật idArea vào hidden field

    // Hiển thị modal
    document.getElementById('addTableModal').style.display = 'block';
}

// Đóng modal
function closeModal(modalId) {
    document.getElementById(modalId).style.display = 'none';
    if (modalId === 'addTableModal') {
        document.getElementById('txtTableName').value = '';
    } else if (modalId === 'addAreaModal') {
        document.getElementById('txtNewFloorName').value = '';
    }
}

// Hiển thị modal thêm khu vực
function showAddAreaModal() {
    document.getElementById('addAreaModal').style.display = 'block';
}

// Toggle submenu
function toggleSubMenu(e) {
    e.preventDefault();
    var submenu = document.getElementById("submenu");
    submenu.classList.toggle("open");
    e.currentTarget.classList.toggle("rotate");
}