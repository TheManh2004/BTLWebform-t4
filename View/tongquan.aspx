<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="tongquan.aspx.cs" Inherits="BTL.View.tongquan" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <title>Tổng quan</title>
   <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
   <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
   <link rel="stylesheet" href="../Style/StyleTongQuan.css" />
</head>
<body>
    <form id="form1" runat="server" style="display: flex;">
     <!-- Sidebar -->
    <div class="sidebar">
        <h2>MENU</h2>
        <a href="BanHang.aspx">Bán hàng</a>
        <a href="tongquan.aspx">Tổng quan</a>
        <a href="SoDoBan.aspx">Sơ đồ bàn</a>
        <div class="box1">
            <a href="DoAn-DoUong.aspx">Đồ uống, món ăn</a>
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
    <!-- Main content -->
    <div class="main-content">
        <div class="header">
            <h1>Tổng quan</h1>
            <div class="notification"><i class="fa-regular fa-bell"></i></div>
        </div>
        <div class="info-cards">
            <div class="card">
                <h3>Doanh thu</h3>
                <p><asp:Literal ID="litRevenue" runat="server">0 đ</asp:Literal></p>
            </div>
            <div class="card">
                <h3>Lợi nhuận</h3>
                <p><asp:Literal ID="litProfit" runat="server">0 đ</asp:Literal></p>
            </div>
            <div class="card">
                <h3>Nhân viên</h3>
                <p><asp:Literal ID="litStaffCount" runat="server">0</asp:Literal></p>
            </div>
            <div class="card">
                <h3>Tổng đơn hàng</h3>
                <p><asp:Literal ID="litOrderCount" runat="server">0</asp:Literal></p>
            </div>
        </div>
    </div>
</form>
<script src="../Scripts/ScriptsCode/TongQuanJs.js"></script>
</body>
</html>