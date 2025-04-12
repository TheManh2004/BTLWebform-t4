<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TTCaNhan.aspx.cs" Inherits="BTL.View.TTCaNhan" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Thông tin cá nhân</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="../Style/StyleTTCaNhan.css" />
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

    <script src="../Scripts/ScriptsCode/TTCaNhanJs.js">
     
    </script>
</body>
</html>