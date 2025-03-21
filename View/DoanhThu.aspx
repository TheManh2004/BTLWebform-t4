<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DoanhThu.aspx.cs" Inherits="BTL.View.DoanhThu" %>

<!DOCTYPE html>

    <html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
    <title>Thống kê doanh thu</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../Style/StyleDoanhThu.css" />
</head>
<body>
    <form id="form1" runat="server" style="display: flex; ">
    <!-- Sidebar -->
    <div class="sidebar">
        <h2>MENU</h2>
        <a href="#">Bán hàng</a>
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
            <h1>Thống kê doanh thu</h1>
            <div class="notification"><i class="fa-regular fa-bell"></i></div>
        </div>

        <!-- Menu Group Table -->
        <div class="menu-container">
             <!-- Filters Section -->
             <div class="filters">
                 <asp:DropDownList ID="timeRange" runat="server" AutoPostBack="true" OnSelectedIndexChanged="timeRange_SelectedIndexChanged">
                    <asp:ListItem Text="Trong ngày" Value="day"></asp:ListItem>
                    <asp:ListItem Text="Trong tuần" Value="week"></asp:ListItem>
                    <asp:ListItem Text="Trong tháng" Value="month"></asp:ListItem>
                </asp:DropDownList>
                 <label for="fromDate">Từ ngày:</label>
                 <asp:TextBox ID="fromDate" runat="server" CssClass="date-picker" TextMode="Date"></asp:TextBox>

                 <label for="toDate">Đến ngày:</label>
                 <asp:TextBox ID="toDate" runat="server" CssClass="date-picker" TextMode="Date"></asp:TextBox>
             </div>
            <hr />
            <!-- Table Section -->
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Thời gian</th>
                            <th>Doanh thu</th>
                            <th>Thuế</th>
                            <th>Lợi nhuận</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>02/03/2025</td>
                            <td>1,499,000</td>
                            <td>89,000</td>
                            <td>?</td>
                        </tr>
                        <tr>
                            <td>03/03/2025</td>
                            <td>2,000,000</td>
                            <td>100,000</td>
                            <td>?</td>
                        </tr>
                        <tr>
                            <td><strong>Tổng cộng</strong></td>
                            <td><strong>3,499,000</strong></td>
                            <td><strong>189,000</strong></td>
                            <td><strong>?</strong></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    </form>
    <script src="../Scripts/ScriptsCode/DoanhThuJS.js">
        
    </script>

</body>
</html>
