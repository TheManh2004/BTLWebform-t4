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
        <a href="Dashboard.aspx">Bán hàng</a>
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
                 
                 <asp:Button ID="btnFilter" runat="server" Text="Lọc" OnClick="LoadRevenueData" CssClass="btn-filter" />
             </div>
            <hr />
            
            <!-- Error Message Panel -->
            <asp:Label ID="lblErrorMessage" runat="server" CssClass="error-message" Visible="false"></asp:Label>
            
            <!-- Table Section -->
            <div class="table-container">
                <asp:GridView ID="revenueGridView" runat="server" AutoGenerateColumns="false" CssClass="revenue-table"
                    EmptyDataText="Không có dữ liệu doanh thu cho khoảng thời gian đã chọn">
                    <Columns>
                        <asp:BoundField DataField="Date" HeaderText="Thời gian" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:BoundField DataField="TotalRevenue" HeaderText="Doanh thu" DataFormatString="{0:N0}" />
                        <asp:BoundField DataField="Tax" HeaderText="Thuế" DataFormatString="{0:N0}" />
                        <asp:BoundField DataField="Profit" HeaderText="Lợi nhuận" DataFormatString="{0:N0}" />
                    </Columns>
                </asp:GridView>
                
                <div class="totals-container">
                    <div class="total-row">
                        <span class="total-label"><strong>Tổng cộng</strong></span>
                        <span class="total-value"><strong><asp:Label ID="lblTotalRevenue" runat="server"></asp:Label></strong></span>
                        <span class="total-value"><strong><asp:Label ID="lblTotalTax" runat="server"></asp:Label></strong></span>
                        <span class="total-value"><strong><asp:Label ID="lblTotalProfit" runat="server"></asp:Label></strong></span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </form>
    <script src="../Scripts/ScriptsCode/DoanhThuJS.js"></script>
</body>
</html>