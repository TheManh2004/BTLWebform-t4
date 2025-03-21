<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TTCaNhan.aspx.cs" Inherits="BTL.View.TTCaNhan" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Thông tin cá nhân</title>
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

        /* Sidebar */
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

        /* Submenu */
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

        /* Rotate icon */
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

        .main-content h2 {
            color: #6F4E37;
        }

        .container {
            display: flex;
            align-items: center;
            justify-content: space-evenly;
        }

        .form-container {
            width: 50%;
            display: flex;
            flex-direction: column;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .form-group input[type="text"],
        .form-group input[type="password"] {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }

        .profile-pic {
            width: 300px;
            height: 300px;
            background-color: #ccc;
            border-radius: 50%;
            display: block;
        }

        .form-button {
            display: flex;
            align-items: center;
            justify-content: space-evenly;
            margin-top: 50px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-update {
            width: 200px;
            height: 50px;
            background-color: #D7B899;
            font-size: 20px;
            color: white;
        }

        .btn-update:hover {
            background-color: #8b5e3c;
        }

        .btn-reset {
            width: 200px;
            height: 50px;
            font-size: 20px;
            background-color: #D7B899;
            color: white;
        }

        .btn-reset:hover {
            background-color: #8b5e3c;
        }

        /* Modal CSS */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            background-color: rgba(0,0,0,0.4);
        }

        .modal-content {
            background-color: #fefefe;
            position: absolute; /* Đặt position absolute để căn giữa trong modal */
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%); /* Căn giữa theo cả ngang và dọc */
            padding: 20px;
            border: 1px solid #888;
            width: 40%;
            max-height: 80vh;
            overflow-y: auto;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        .modal-content h2 {
            color: #6F4E37;
            margin-top: 0;
        }

        .modal-content label {
            display: block;
            margin: 10px 0 5px;
            color: #6F4E37;
        }

        .modal-content input {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
        }

        .modal-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .btnSave, .btnCancel {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .btnSave {
            background-color: #4CAF50;
            color: white;
        }

        .btnSave:hover {
            background-color: #45a049;
        }

        .btnCancel {
            background-color: #f44336;
            color: white;
        }

        .btnCancel:hover {
            background-color: #da190b;
        }

        body.modal-open {
            overflow: hidden;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" style="display: flex;">
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
            <a href="DoanhThu.aspx">Thông kê doanh thu</a>
            <a href="DonHang.aspx">Quản lý đơn hàng</a>
            <a href="qlNV.aspx">Quản lý nhân viên</a>
            <a href="NguyenLieu.aspx">Quản Lý nguyên liệu</a>
            <a href="TTCaNhan.aspx">Thông tin cá nhân</a>
            <asp:Button ID="BtnLogout" runat="server" Text="Đăng xuất" class="btnlogout" OnClick="BtnLogout_Click" />
        </div>

        <div class="main-content">
            <h2>Thông tin cá nhân</h2>
            <div class="container">
                <div class="profile-pic"></div>
                <div class="form-container">
                    <div class="form-group">
                        <label>Tên đăng nhập</label>
                        <asp:TextBox ID="txtUsername" runat="server"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Họ và tên</label>
                        <asp:TextBox ID="txtFullName" runat="server"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Số điện thoại</label>
                        <asp:TextBox ID="txtPhone" runat="server"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Địa chỉ</label>
                        <asp:TextBox ID="txtAddress" runat="server"></asp:TextBox>
                    </div>
                </div>
            </div>
            <div class="form-button">
                <asp:Button ID="btnReset" runat="server" Text="Đặt lại mật khẩu" CssClass="btn btn-reset" OnClientClick="showModal(); return false;" />
                <asp:Button ID="btnUpdate" runat="server" Text="Cập nhật" CssClass="btn btn-update" OnClick="btnUpdate_Click" />
            </div>

            <!-- Modal for Reset Password -->
            <div id="resetPasswordModal" class="modal">
                <div class="modal-content">
                    <h2>Đặt lại mật khẩu</h2>
                    <label>Mật khẩu hiện tại</label>
                    <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" />
                    <label>Mật khẩu mới</label>
                    <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" />
                    <label>Nhập lại mật khẩu</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" />
                    <div class="modal-buttons">
                        <asp:Button ID="btnSavePassword" runat="server" Text="Lưu" CssClass="btnSave" OnClick="btnSavePassword_Click" />
                        <asp:Button ID="btnCancel" runat="server" Text="Hủy" CssClass="btnCancel" OnClientClick="hideModal(); return false;" />
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script>
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
    </script>
</body>
</html>