<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AnUong.aspx.cs" Inherits="BTL.View.AnUong" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Đồ uống/món ăn</title>
   <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
   <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../Style/StyleAnUong.css" />
</head>
<body>
    <form id="form1" runat="server" style="display: flex; ">
    <!-- Sidebar -->
    <div class="sidebar">
        <h2>MENU</h2>
        <a href="Dashboard.aspx">Bán hàng...</a>
        <a href="tongquan.aspx">Tổng quan</a>
        <a href="SoDoBan.aspx">Sơ đồ bàn</a>
        <div class="box1" >
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

    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <h1>Đồ uống/món ăn</h1>
            <div class="notification"><i class="fa-regular fa-bell"></i></div>
        </div>

        <div class="form-container">
            <h3>Thêm đồ uống/món ăn</h3>
            <hr />
            <div class="content">
                <div class="content-up">
                    <asp:TextBox ID="txtDishName" runat="server" placeholder="Tên món" style="width: 400px" />
                    <asp:DropDownList ID="ddlCategory" runat="server" style="width: 300px">
                        <asp:ListItem Text="Danh mục" Value="unit" />
                        <asp:ListItem Text="Nhóm đồ uống" Value="drink" />
                        <asp:ListItem Text="Món ăn" Value="food" />
                    </asp:DropDownList>
                    <asp:DropDownList ID="ddlStatus" runat="server" style="width: 202px;">
                        <asp:ListItem Text="Trạng thái" Value="unit" />
                        <asp:ListItem Text="Hoạt động" Value="active" />
                        <asp:ListItem Text="Ngừng hoạt động" Value="inactive" />
                    </asp:DropDownList>
                </div>
                 <div class="content-down">
                    <asp:TextBox ID="txtPrice" runat="server" placeholder="Giá" style="width: 400px"/>
                    <asp:DropDownList ID="ddlUnit" runat="server" style="width: 300px">
                        <asp:ListItem Text="Đơn vị tính" Value="unit" />
                        <asp:ListItem Text="Chiếc" Value="piece" />
                        <asp:ListItem Text="Cốc" Value="liter" />
                    </asp:DropDownList>
                </div>
                <asp:Button ID="btnCreate" class="btnCreate" runat="server" Text="+ Tạo mới" style="width: 200px; height: 40px" OnClick="btnCreate_Click" />
            </div>
        </div>

        <!-- Menu Group Table -->
        <div class="menu-container">
            <h3>Danh sách đồ uống/món ăn</h3>
            <hr />
             <div class="search">
                <asp:TextBox ID="txtSearch" class="txtSearch" runat="server" placeholder="Tìm kiếm theo tên nhóm..." />
                <asp:DropDownList ID="ddlSearchCategory" runat="server">
                    <asp:ListItem Text="Danh mục" Value="unit" />
                    <asp:ListItem Text="Nhóm đồ uống" Value="drink" />
                    <asp:ListItem Text="Món ăn" Value="food" />
                </asp:DropDownList>
                <asp:DropDownList ID="ddlSearchUnit" runat="server">
                    <asp:ListItem Text="Đơn vị tính" Value="unit" />
                    <asp:ListItem Text="Chiếc" Value="piece" />
                    <asp:ListItem Text="Cốc" Value="liter" />
                </asp:DropDownList>
                <asp:Button ID="btnSearch" class="btnSearch" runat="server" Text="Tìm kiếm" OnClick="btnSearch_Click" />
            </div>
            <table>
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Tên đồ</th>
                        <th>Danh mục</th>
                        <th>Đơn vị tính</th>
                        <th>Giá</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>1</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td class="actions">
                            <asp:Button ID="btnEdit1" runat="server" Text="Cập nhật" CssClass="edit" OnClick="btnEdit_Click" />
                            <asp:Button ID="btnDelete1" runat="server" Text="Xóa" CssClass="delete" OnClick="btnDelete_Click" />
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    </form>
    <script src="../Scripts/ScriptsCode/AnUongJS.js">
   
    </script>

</body>
</html>
