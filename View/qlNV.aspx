<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="qlNV.aspx.cs" Inherits="BTL.View.qlNV" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Quản lý nhân viên</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="../Style/StyleQlNV.css" />
</head>
<body>
    <form id="form1" runat="server" style="display: flex;">
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
                <asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="False" CssClass="table"  OnRowDeleting="gvEmployees_RowDeleting">
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
                                    <asp:Button ID="btnEdit" runat="server" Text="Cập nhật" CssClass="edit" 
    CommandArgument='<%# Eval("Username") %>' OnCommand="btnEdit_Command" />
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

             <div id="editEmployeeModal" class="modal">
     <div class="modal-content">
         <h2>Chỉnh sửa nhân viên</h2>
         <label>Tên đăng nhập</label>
         <asp:TextBox ID="TextBox1" runat="server" />
         <label>Họ và tên</label>
         <asp:TextBox ID="TextBox2" runat="server" />
         <label>Địa chỉ</label>
         <asp:TextBox ID="TextBox3" runat="server" />
         <label>Số điện thoại</label>
         <asp:TextBox ID="TextBox4" runat="server" />
         <label>Mật khẩu</label>
         <asp:TextBox ID="TextBox5" runat="server" TextMode="Password" />
         <label>Trạng thái</label>
         <asp:DropDownList ID="DropDownList1" runat="server">
             <asp:ListItem Text="Hoạt động" Value="Hoạt động" />
             <asp:ListItem Text="Ngừng hoạt động" Value="Ngừng hoạt động" />
         </asp:DropDownList>
         <div class="modal-buttons">
             <asp:Button ID="Button1" runat="server" Text="Lưu" CssClass="btnSave" OnClick="UpdateEmployee" />
             <asp:Button ID="Button2" runat="server" Text="Hủy" CssClass="btnCancel" OnClientClick="hideeditModal(); return false;" />
         </div>
     </div>
 </div>

        </div>
    </form>

    <script src="../Scripts/ScriptsCode/qlNVJS.js"></script>
</body>
</html>