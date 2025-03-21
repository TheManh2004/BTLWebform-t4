<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="qlNV.aspx.cs" Inherits="BTL.View.qlNV" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Quản lý nhân viên</title>
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

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            margin-top: 15px;
        }

        .header h1 {
            font-size: 28px;
            margin: 0;
            color: #6F4E37;
        }

        .header .notification {
            font-size: 20px;
            color: #6F4E37;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 30px;
        }

        table, th, td {
            border: 1px solid #6F4E37;
        }

        th, td {
            padding: 12px;
            text-align: center;
        }

        th {
            background-color: #fff;
            color: #6F4E37;
        }

        td {
            background-color: #fff;
            color: #6F4E37;
        }

        .actions .edit {
            background-color: #4CAF50;
            color: white;
            padding: 6px 12px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
        }

        .actions .delete {
            background-color: #F2BB42;
            color: white;
            padding: 6px 12px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
        }

        .actions .edit:hover,
        .actions .delete:hover {
            opacity: 0.8;
        }

        .menu-container {
            padding: 20px;
            border-radius: 8px;
            background-color: #fff;
            margin: 20px auto;
            box-shadow: 4px 8px 20px rgba(210, 180, 140, 0.9);
        }

        .menu-container hr {
            border: 0;
            border-top: 2px solid #6B3E2F;
            margin: 20px -20px;
        }

        .search {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .search-container {
            position: relative;
            display: inline-block;
        }

        .txtSearch {
            padding: 10px;
            padding-right: 35px;
            border-radius: 5px;
            border: 1px solid #ddd;
            font-size: 16px;
            width: 500px;
        }

        .search-icon {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: #6F4E37;
            font-size: 16px;
            padding-left: 8px;
        }

        .btnAdd {
            background-color: #D2B48C;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            width: 200px;
            height: 40px;
        }

        .btnAdd:hover {
            background-color: #8B5E3B;
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
            margin: 5% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 40%;
            max-height: 80vh;
            overflow-y: auto;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            position: relative;
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

        .modal-content input, .modal-content select {
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
            <div class="header">
                <h1>Quản lý nhân viên</h1>
                <div class="notification"><i class="fa-regular fa-bell"></i></div>
            </div>

            <div class="menu-container">
                <div class="search">
                    <div class="search-container">
                        <asp:TextBox ID="txtSearch" class="txtSearch" runat="server" placeholder="Tìm kiếm theo tên..." />
                        <i class="fa-solid fa-magnifying-glass search-icon"></i>
                    </div>
                    <asp:Button ID="btnAdd" class="btnAdd" runat="server" Text="Tạo mới" OnClientClick="showModal(); return false;" />
                </div>
                <hr />
                <asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="False" CssClass="table" 
                    OnRowEditing="gvEmployees_RowEditing" OnRowDeleting="gvEmployees_RowDeleting">
                    <Columns>
                        <asp:BoundField DataField="STT" HeaderText="STT" ReadOnly="True" />
                        <asp:BoundField DataField="Username" HeaderText="Tên đăng nhập" />
                        <asp:BoundField DataField="FullName" HeaderText="Họ tên" />
                        <asp:BoundField DataField="Address" HeaderText="Địa chỉ" />
                        <asp:BoundField DataField="PhoneNumber" HeaderText="Số điện thoại" />
                        <asp:BoundField DataField="Status" HeaderText="Trạng thái" />
                        <asp:TemplateField HeaderText="Thao tác">
                            <ItemTemplate>
                                <div class="actions">
                                    <asp:Button ID="btnEdit" runat="server" Text="Cập nhật" CssClass="edit" CommandName="Edit" />
                                    <asp:Button ID="btnDelete" runat="server" Text="Xóa" CssClass="delete" CommandName="Delete" />
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <div id="addEmployeeModal" class="modal">
                <div class="modal-content">
                    <h2>Thêm mới nhân viên</h2>
                    <label>Tên đăng nhập</label>
                    <asp:TextBox ID="txtUsername" runat="server" />
                    <label>Họ và tên</label>
                    <asp:TextBox ID="txtFullName" runat="server" />
                    <label>Địa chỉ</label>
                    <asp:TextBox ID="txtAddress" runat="server" />
                    <label>Số điện thoại</label>
                    <asp:TextBox ID="txtPhoneNumber" runat="server" />
                    <label>Mật khẩu</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" />
                    <label>Trạng thái</label>
                    <asp:DropDownList ID="ddlStatus" runat="server">
                        <asp:ListItem Text="Hoạt động" Value="Hoạt động" />
                        <asp:ListItem Text="Ngừng hoạt động" Value="Ngừng hoạt động" />
                    </asp:DropDownList>
                    <div class="modal-buttons">
                        <asp:Button ID="btnSave" runat="server" Text="Lưu" CssClass="btnSave" OnClick="btnSave_Click" />
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
            document.getElementById("addEmployeeModal").style.display = "block";
            document.body.classList.add("modal-open");
        }

        function hideModal() {
            document.getElementById("addEmployeeModal").style.display = "none";
            document.body.classList.remove("modal-open");
        }
    </script>
</body>
</html>