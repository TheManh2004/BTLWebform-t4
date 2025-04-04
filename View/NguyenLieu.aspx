﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NguyenLieu.aspx.cs" Inherits="BTL.View.Hang" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Quản Lý Nguyên Liệu</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
     <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../Style/StyleNguyenLieu.css" />
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

    <script src="../Scripts/ScriptsCode/NguyenLieuJS.js">
       
    </script>
</body>
</html>