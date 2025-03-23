<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DonHang.aspx.cs" Inherits="BTL.View.DonHang" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Quản lý đơn hàng</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../Style/StyleDonHang.css" />
</head>
<body>
    <form id="form1" runat="server" style="display: flex; ">
    <div class="sidebar">
        <h2>MENU</h2>
        <a href="#">Bán hàng</a>
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
    <script src="../Scripts/ScriptsCode/DonHangJS.js">
    
    </script>
</body>
</html>