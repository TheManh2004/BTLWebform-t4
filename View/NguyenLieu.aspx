<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NguyenLieu.aspx.cs" Inherits="BTL.View.Hang" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Quản Lý Nguyên Liệu</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
     <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <style type="text/css">
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

        .search-container {
            margin: 20px 0;
            display: flex;
            gap: 30px;
            align-items: center;
        }

        .search-box {
            padding: 10px;
            width: 450px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .btn-search {
             background-color: #D2B48C; /* Màu nền của nút */
             color: white;
             border: none;
             padding: 10px 20px;
             border-radius: 5px;
             cursor: pointer;
             width: 150px;
             font-size: 16px;
        }

        .btn-search:hover {
            background-color: #8B5E3B;
        }

        .btn-add {
             background-color: #D2B48C; /* Màu nền của nút */
             color: white;
             border: none;
             padding: 10px 20px;
             border-radius: 5px;
             cursor: pointer;
             width: 150px;
             font-size: 16px;
        }

        .btn-add:hover {
            background-color: #8B5E3B;
        }

        .gridview {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        .gridview th, .gridview td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
            color: #6F4E37;
        }
        .gridview th {
            background-color: #fff;
        }
        .btn-update {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 5px 10px;
            cursor: pointer;
            border-radius: 4px;
        }
        .btn-delete {
            background-color: #ffcc00;
            color: black;
            border: none;
            padding: 5px 10px;
            cursor: pointer;
            border-radius: 4px;
        }
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

    </style>
</head>
<body>
    <form id="form1" runat="server" style="display: flex;">
        <!-- Sidebar -->
        <div class="sidebar">
            <h2>MENU</h2>
            <a href="Dashboard.aspx">Bán hàng</a>
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

        <!-- Main content -->
        <div class="main-content">
            <div class="header">
                <h1>Quản lý nguyên liệu</h1>
                <div class="notification"><i class="fa-regular fa-bell"></i></div>
            </div>
            <div class="menu-container">
                <div class="search-container">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="search-box" Placeholder="Tìm kiếm" />
                    <asp:Button ID="btnSearch" runat="server" Text="Tìm kiếm" CssClass="btn-search" OnClick="btnSearch_Click" />
                    <asp:Button ID="btnAdd" runat="server" Text="Tạo mới" CssClass="btn-add" OnClientClick="showModal(); return false;" />
                </div>
                <hr />
                <!-- Modal for adding new inventory item -->
                <div id="addHangModal" class="modal">
                    <div class="modal-content">
                        <h2>Thêm nguyên liệu</h2>
                        <label>Mã sản phẩm</label>
                        <asp:TextBox ID="txtMaSanPham" runat="server" />
                        <label>Tên sản phẩm</label>
                        <asp:TextBox ID="txtTenSanPham" runat="server" />
                        <label>Số lượng</label>
                        <asp:TextBox ID="txtSoLuong" runat="server" TextMode="Number" />
                        <label>Định lượng</label>
                        <asp:TextBox ID="txtDinhLuong" runat="server" />
                        <div class="modal-buttons">
                            <asp:Button ID="btnSave" runat="server" Text="Lưu" CssClass="btnSave" OnClick="btnSave_Click" />
                            <asp:Button ID="btnCancel" runat="server" Text="Hủy" CssClass="btnCancel" OnClientClick="hideModal(); return false;" />
                        </div>
                    </div>
                </div>

                <!-- GridView for Inventory -->
                <asp:GridView ID="gvInventory" runat="server" AutoGenerateColumns="False" CssClass="gridview" OnSelectedIndexChanged="gvInventory_SelectedIndexChanged">
                    <Columns>
                        <asp:BoundField DataField="STT" HeaderText="STT" />
                        <asp:BoundField DataField="MaSanPham" HeaderText="Mã sản phẩm" />
                        <asp:BoundField DataField="TenSanPham" HeaderText="Tên sản phẩm" />
                        <asp:BoundField DataField="SoLuong" HeaderText="Số lượng" />
                        <asp:BoundField DataField="DinhLuong" HeaderText="Định lượng" />
                        <asp:TemplateField HeaderText="Thao tác">
                            <ItemTemplate>
                                <asp:Button ID="btnUpdate" runat="server" Text="Cập nhật" CssClass="btn-update" OnClick="btnUpdate_Click" />
                                <asp:Button ID="btnDelete" runat="server" Text="Xóa" CssClass="btn-delete" OnClick="btnDelete_Click" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>

    <script>
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

        function showModal() {
            document.getElementById("addHangModal").style.display = "block";
        }

        function hideModal() {
            document.getElementById("addHangModal").style.display = "none";
        }
    </script>
</body>
</html>