<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SoDoBan.aspx.cs" Inherits="BTL.View.SoDoBan" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sơ đồ bàn</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet" />
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            height: 100vh;
            background-color: #f4f1e1;
        }

        .sidebar {
            width: 250px;
            background-color: #6F4E37;
            color: white;
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .sidebar h2 {
            margin-bottom: 20px;
            margin-left: 10px;
        }

        .sidebar a {
            text-decoration: none;
            color: white;
            padding: 10px;
            border-radius: 5px;
            display: block;
        }

        .sidebar a:hover {
            background-color: #D2B48C;
        }

        .box1 {
            text-decoration: none;
            color: white;
            border-radius: 5px;
            display: block;
            text-align: center;
            cursor: pointer;
        }

        .box1 {
            display: flex;
            justify-content: flex-start;
            align-items: center;
            gap: 80px;
        }

        .box1:hover {
            background-color: #D2B48C;
        }

        .submenu {
            display: none;
            flex-direction: column;
            margin-left: 20px;
            padding-top: 10px;
        }

        .submenu a {
            text-decoration: none;
            color: white;
            padding: 8px;
            border-radius: 5px;
        }

        .submenu a:hover {
            background-color: #D2B48C;
        }

        .rotate {
            transition: transform 0.3s ease;
        }

        .rotate-down {
            transform: rotate(90deg);
        }

        .btnlogout{
            background: none;
            border: none;
            color: white;
            font-size: 16px;
            text-decoration: none;
            color: white;
            padding: 10px;
            border-radius: 5px;
            text-align:left;
            cursor: pointer;
        }

        .btnlogout:hover {
            background-color: #D2B48C;
        }

        /*main-content*/
        .main-content {
            flex: 1;
            background-color: #FFF8DC;
            padding: 20px;
            overflow-y: auto;
            width: 1204px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            margin-top: 15px;
        }

        .header h1 {
            font-size: 24px;
            margin: 0;
            color: #6F4E37;
        }

        .header .notification {
            font-size: 20px;
            color: #6F4E37;
        }

        .floor-tabs {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .btn-floor {
            width: 100px;
            border: none;
            background: none;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
        }

        .btn-floor.active {
            background-color: #D2B48C;
            border-radius: 5px;
        }

        .btn-add {
            width: 150px;
            border: none;
            background-color: #D2B48C;
            padding: 10px 20px;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
        }

        .btn-add:hover {
            background-color: #8B5E3B;
        }

        .table-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-start;
            gap: 20px;
            margin-top: 20px;
        }

        .table-container .table-box {
            width: 150px;
            height: 150px;
            background-color: white;
            border: 1px solid #D2B48C;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            border-radius: 10px;
            cursor: pointer;
        }

        .table-container .add-table {
            width: 150px;
            height: 150px;
            background-color: #fff;
            border: 1px dashed #D2B48C;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            border-radius: 10px;
            cursor: pointer;
        }

        .add-table:hover {
            background-color: #f4e1a1;
        }

        #addTableModal, #addAreaModal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
            z-index: 10000;
        }

        .modal-content {
            background: white;
            padding: 20px;
            border-radius: 10px;
            width: 300px;
            position: relative;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .modal-content h3 {
            margin: 0 0 15px;
            font-size: 18px;
            color: #333;
        }

        .modal-content .close {
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 24px;
            cursor: pointer;
            color: #666;
        }

        .modal-content label {
            display: block;
            margin-bottom: 5px;
            font-size: 14px;
            color: #333;
        }

        .modal-content input[type="text"] {
            width: 94%;
            padding: 8px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }

        .modal-content .buttons {
            display: flex;
            justify-content: space-between;
        }

        .modal-content .buttons input[type="button"],
        .modal-content .buttons input[type="submit"] {
            padding: 8px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }

        .modal-content .buttons input[type="button"] {
            background: #ccc;
            color: #333;
        }

        .modal-content .buttons input[type="submit"] {
            background: #D2B48C;
            color: white;
        }

        .modal-content .buttons input[type="submit"]:hover {
            background: #8B5E3B;
        }


    </style>
</head>
<body>
    <form id="form1" runat="server" style="display: flex;">
        <!-- Hidden Field to Store Current Floor -->
        <asp:HiddenField ID="hdnCurrentFloor" runat="server" Value="1" ClientIDMode="Static" />

        <!-- Sidebar -->
        <div class="sidebar">
            <h2>MENU</h2>
            <a href="#">Bán hàng</a>
            <a href="tongquan.aspx">Tổng quan</a>
            <a href="SoDoBan.aspx">Sơ đồ bàn</a>
            <div class="box1">
                <a href="AnUong.aspx">Đồ uống, món ăn</a>
                <i class="fa-solid fa-caret-right rotate" id="icon" onclick="toggleSubMenu(event)"></i>
            </div>
            <div class="submenu" id="submenu">
                <a href="ThucDon.aspx">Nhóm thực đơn</a>
                <a href="DonViTinh.aspx">Đơn vị tính</a>
            </div>
            <a href="DoanhThu.aspx">Thống kê doanh thu</a>
            <a href="DonHang.aspx">Quản lý đơn hàng</a>
            <a href="qlNV.aspx">Quản lý nhân viên</a>
            <a href="NguyenLieu.aspx">Quản Lý nguyên liệu</a>
            <a href="TTCaNhan.aspx">Thông tin cá nhân</a>
            <asp:Button ID="BtnLogout" runat="server" Text="Đăng xuất" class="btnlogout" OnClick="BtnLogout_Click" />
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <h1>Sơ đồ bàn</h1>
                <div class="notification"><i class="fa-regular fa-bell"></i></div>
            </div>

            <div class="floor-tabs" id="floorTabs" runat="server">
                <div id="floorButtons" runat="server">
                    <asp:Button ID="btnFloor1" CssClass="btn-floor active" runat="server" Text="Tầng 1" OnClick="btnFloor_Click" CommandArgument="1" />
                    <asp:Button ID="btnFloor2" CssClass="btn-floor" runat="server" Text="Tầng 2" OnClick="btnFloor_Click" CommandArgument="2" />
                    <asp:Button ID="btnFloor3" CssClass="btn-floor" runat="server" Text="Tầng 3" OnClick="btnFloor_Click" CommandArgument="3" />
                </div>
                <asp:Button ID="btnAddArea" CssClass="btn-add" runat="server" Text="+ Thêm khu vực" OnClientClick="showAddAreaModal(); return false;" OnClick="btnAddArea_Click" />
            </div>
            <hr />
            <div class="table-container" id="tableContainer" runat="server">
                <asp:Button ID="btnAddTable" runat="server" Text="+ Thêm bàn" CssClass="add-table" OnClientClick="showAddTableModal(document.getElementById('hdnCurrentFloor').value); return false;" OnClick="btnAddTable_Click" />
            </div>
        </div>

        <!-- Add Table Modal -->
        <div id="addTableModal" style="display:none;">
            <div class="modal-content">
                <div>
                    <h3>Thêm bàn</h3>
                    <span class="close" onclick="closeModal('addTableModal')">×</span>
                </div>
                <asp:HiddenField ID="hdnFloor" runat="server" ClientIDMode="Static" />
                <div>
                    <label>Tầng</label>
                    <asp:TextBox ID="txtFloor" runat="server" ReadOnly="true" ClientIDMode="Static" />
                </div>
                <div>
                    <label>Tên bàn</label>
                    <asp:TextBox ID="txtTableName" runat="server" ClientIDMode="Static" />
                </div>
                <div class="buttons">
                    <asp:Button ID="btnCloseModal" runat="server" Text="Đóng" OnClientClick="closeModal('addTableModal'); return false;" />
                    <asp:Button ID="btnSaveTable" runat="server" Text="Lưu" OnClick="btnSaveTable_Click" />
                </div>
            </div>
        </div>

        <!-- Add Area Modal -->
        <div id="addAreaModal" style="display:none;">
            <div class="modal-content">
                <span class="close" onclick="closeModal('addAreaModal')">×</span>
                <h3>Thêm khu vực</h3>
                <div>
                    <label>Tầng</label>
                    <asp:TextBox ID="txtNewFloorName" runat="server" ClientIDMode="Static" />
                </div>
                <div class="buttons">
                    <asp:Button ID="btnCloseAreaModal" runat="server" Text="Đóng" OnClientClick="closeModal('addAreaModal'); return false;" />
                    <asp:Button ID="btnSaveArea" runat="server" Text="Lưu" OnClick="btnSaveArea_Click" />
                </div>
            </div>
        </div>
    </form>

    <script type="text/javascript">
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
    </script>
    <script>
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
    </script>
</body>
</html>