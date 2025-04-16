<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ThucDon.aspx.cs" Inherits="BTL.View.ThucDon" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Nhóm thực đơn</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../Style/StyleThucDon.css" />
</head>
<body>
    <form id="form1" runat="server" style="display: flex; ">
    <!-- Sidebar -->
    <div class="sidebar">
        <h2>MENU</h2>
        <a href="BanHang.aspx">Bán hàng</a>
        <a href="tongquan.aspx">Tổng quan</a>
        <a href="SoDoBan.aspx">Sơ đồ bàn</a>
        <div class="box1" >
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
        <asp:Button ID="BtnLogout" runat="server" Text="Đăng xuất" class="btnlogout" OnClick="btnLogout_Click" />
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <h1>Nhóm thực đơn</h1>
            <div class="notification"><i class="fa-regular fa-bell"></i></div>
        </div>

        <!-- Add new menu group form -->
        <div class="form-container">
            <h3>Thêm nhóm thực đơn</h3>
            <hr />
           <div class="content">
                <asp:TextBox ID="txtGroupName" runat="server" placeholder="Tên nhóm thực đơn" style="width: 450px" />
                <asp:DropDownList ID="ddlStatus" runat="server" style="width: 300px;">
                    <asp:ListItem Text="Trạng thái" Value="unit" />
                    <asp:ListItem Text="Hoạt động" Value="active" />
                    <asp:ListItem Text="Ngừng hoạt động" Value="inactive" />
                </asp:DropDownList>
                <asp:Button ID="btnCreate" class="btnCreate" runat="server" Text="+ Tạo mới" style="width: 200px; height: 40px" OnClick="btnCreate_Click" />
            </div>
        </div>

        <!-- Menu Group Table -->
        <div class="menu-container">
            <h3>Danh sách nhóm thực đơn</h3>
            <hr />
            <div class="search">
                <asp:TextBox ID="txtSearch" class="txtSearch" runat="server" placeholder="Tìm kiếm theo tên nhóm..." />
                <asp:Button ID="btnSearch" class="btnSearch" runat="server" Text="Tìm kiếm" OnClick="btnSearch_Click" />
            </div>
           <asp:GridView ID="GridView1" runat="server" 
               AutoGenerateColumns="False" CssClass="table" 
               OnRowDeleting="GridView1_RowDeleting" 
               OnRowEditing="GridView1_RowEditing" 
               OnRowUpdating="GridView1_RowUpdating" 
               DataKeyNames="FoodCategory_id" 
               OnRowDataBound="GridView1_RowDataBound">
    <Columns>
        <asp:BoundField DataField="FoodCategory_id" HeaderText="STT" SortExpression="FoodCategory_id" />
        <asp:BoundField DataField="FoodCategory_name" HeaderText="Tên nhóm" SortExpression="FoodCategory_name" />
        <asp:BoundField DataField="Description" HeaderText="Mô tả" SortExpression="Description" />
        <asp:BoundField DataField="status" HeaderText="Trạng thái" SortExpression="status" />
        <asp:TemplateField HeaderText="Thao tác">
            <ItemTemplate>
                <!-- Nút Cập nhật -->
                <asp:Button ID="btnEdit" runat="server" Text="Cập nhật" CssClass="btnedit" CommandName="Edit" 
                    CommandArgument='<%# Eval("FoodCategory_id") %>' />
                <!-- Nút Xóa -->
                <asp:Button ID="btnDelete" runat="server" Text="Xóa" CssClass="btndelete" CommandName="Delete" 
                    CommandArgument='<%# Eval("FoodCategory_id") %>' OnClientClick="return confirm('Bạn có chắc chắn muốn xóa nhóm thực đơn này không?');" />
            </ItemTemplate>
            <EditItemTemplate>
                <!-- Các ô chỉnh sửa trong chế độ Edit -->
                <asp:TextBox ID="txtEditFoodCategoryName" runat="server" Text='<%# Eval("FoodCategory_name") %>' />
                <asp:TextBox ID="txtEditDescription" runat="server" Text='<%# Eval("Description") %>' />
                <!-- DropdownList trạng thái cho chế độ chỉnh sửa -->
                <asp:DropDownList ID="ddlEditStatus" runat="server">
                    <asp:ListItem Text="Hoạt động" Value="1" />
                    <asp:ListItem Text="Ngừng hoạt động" Value="0" />
                </asp:DropDownList>
                <!-- Nút Lưu thay đổi -->
                <asp:Button ID="btnUpdate" runat="server" Text="Lưu thay đổi" CommandName="Update" CssClass="update" />
                <!-- Nút Hủy -->
                <asp:Button ID="btnCancel" runat="server" Text="Hủy" CommandName="Cancel" CssClass="cancel" />
            </EditItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>
        </div>
    </div>
    </form>
</body>
</html>
