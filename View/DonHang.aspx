<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DonHang.aspx.cs" Inherits="BTL.View.DonHang" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Quản lý đơn hàng</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            display: flex;
            margin: 0;
            padding: 0;
            height: 100vh;
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
            align-items: center;
            gap: 30px;
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

        /* Search Container */

        /* Dropdown */
        .dropdown {
            padding: 10px 15px; /* Padding lớn hơn một chút cho dễ nhìn */
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
            color: #6F4E37;
            background-color: #fff;
            cursor: pointer;
            transition: all 0.3s ease; /* Hiệu ứng chuyển đổi mượt mà */
            width: 472px; /* Độ rộng cố định cho dropdown */
        }

        .dropdown:focus {
            outline: none;
            border-color: #D2B48C; /* Đổi màu viền khi focus */
            box-shadow: 0 0 5px rgba(210, 180, 140, 0.5); /* Hiệu ứng bóng nhẹ */
        }

        /* Export Button */
        .btn-export {
            width: 151px;
            background-color: #D2B48C;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease; /* Hiệu ứng đổi màu mượt mà */
        }

        .btn-export:hover {
            background-color: #8B5E3B; /* Màu tối hơn khi hover */
        }

        /* Update Button */
        .btn-update {
            width: 150px;
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease; /* Hiệu ứng đổi màu mượt mà */
        }

        .btn-update:hover {
            background-color: #45a049; /* Màu tối hơn khi hover */
        }
        
    </style>
</head>
<body>
    <form id="form1" runat="server" style="display: flex; ">
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
        <div class="header">
            <h1>Quản lý đơn hàng</h1>
            <div class="notification"><i class="fa-regular fa-bell"></i></div>
        </div>
        <div class="menu-container">
            <div class="search-container">
                <asp:TextBox ID="txtSearch" runat="server" class="search-box" placeholder="Tìm kiếm"></asp:TextBox>
                <asp:Button ID="btnSearch" runat="server" Text="Tìm kiếm" class="btn-search" OnClick="btnSearch_Click" />
            </div>
            <div class="search-container">
                <asp:DropDownList ID="ddlStatus" runat="server" class="dropdown" AutoPostBack="true" OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged">
                    <asp:ListItem Text="Tất cả đơn hàng" Value="TatCa" />
                    <asp:ListItem Text="Đã thanh toán" Value="DaThanhToan" />
                    <asp:ListItem Text="Chưa thanh toán" Value="ChuaThanhToan" />
                    <asp:ListItem Text="Đã hủy" Value="DaHuy" />
                </asp:DropDownList>
                <asp:Button ID="btnExport" runat="server" Text="Xuất Excel" class="btn-export" OnClick="btnExport_Click" />
                <asp:Button ID="btnUpdate" runat="server" Text="Cập nhật" class="btn-update" OnClick="btnUpdate_Click" />
            </div>
            <hr />
            <!-- GridView for Inventory -->
            <asp:GridView ID="gvInventory" runat="server" AutoGenerateColumns="False" CssClass="gridview" OnSelectedIndexChanged="gvInventory_SelectedIndexChanged">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:CheckBox ID="chkRow" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="STT" HeaderText="STT" />
                    <asp:BoundField DataField="MaHoaDon" HeaderText="Mã hóa đơn" />
                    <asp:BoundField DataField="NgayGiao" HeaderText="Ngày giao" />
                    <asp:BoundField DataField="NhanVien" HeaderText="Nhân viên" />
                    <asp:BoundField DataField="TongTien" HeaderText="Tổng tiền" />
                    <asp:BoundField DataField="ThanhToan" HeaderText="Thanh toán" />
                    <asp:BoundField DataField="TrangThai" HeaderText="Trạng thái" />
                    <asp:BoundField DataField="GhiChu" HeaderText="Ghi chú" />
                </Columns>
            </asp:GridView>
        </div>
    </div>
</form>
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