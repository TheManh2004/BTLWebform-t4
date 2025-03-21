<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DoanhThu.aspx.cs" Inherits="BTL.View.DoanhThu" %>

<!DOCTYPE html>

    <html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
    <title>Thống kê doanh thu</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            height: 100vh;
            background-color: #f4f1e1;
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

        /* Main Content */
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

        .content{
            display: flex;
/*          align-items: center;*/
           justify-content: space-between;
        }

        /* Định dạng cho khung viền */
        .form-container {
            padding: 20px;
            border-radius: 8px; /* Bo góc cho viền */
            background-color: #fff; /* Màu nền nhẹ */
            margin: 20px auto; /* Canh giữa và tạo khoảng cách */
            box-shadow: 4px 8px 20px rgba(210, 180, 140, 0.9);
        }

        /* Định dạng phần tiêu đề */
        .form-container h3 {
            font-size: 24px;
            color: #6F4E37; /* Màu nâu đậm cho tiêu đề */
        }

        /* Định dạng đường kẻ ngăn cách */
        .form-container hr {
            border: 0;
            border-top: 2px solid #6B3E2F; /* Màu nâu cho đường kẻ */
            margin: 20px -20px; /* Khoảng cách từ đường kẻ đến các phần tử */
        }

        /* Định dạng các phần tử bên trong form */
        .content {
            display: flex;
            gap: 15px;
            flex-wrap: wrap; /* Cho phép các phần tử xuống dòng khi cần */
        }

        /* Định dạng các trường input và select */
        .content input,
        .content select {
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #ddd;
            font-size: 16px;
            margin-bottom: 10px;
        }

        /* Định dạng nút bấm */
        .btnCreate {
            background-color: #D2B48C; /* Màu nền của nút */
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        .btnCreate:hover {
            background-color: #8B5E3B; /* Màu nền thay đổi khi hover */
        }

        /* Table */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 30px;
        }

        table, th, td {
            border: 1px solid #6F4E37;
        }

        th, td {
            padding: 12px;
            text-align: center;
        }

        th {
            background-color: #fff;
            color: #6F4E37;
        }

        td {
            background-color: #fff;
            color: #6F4E37;
        }

        .actions {
/*            display: flex;
            justify-content: center;
            gap: 10px;*/
        }

        .actions .edit {
            background-color: #4CAF50;
            color: white;
            padding: 6px 12px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
        }

        .actions .delete {
            background-color: #F2BB42;
            color: white;
            padding: 6px 12px;
            border-radius: 5px;
            border: none;
            cursor: pointer;
        }

        .actions .delete:hover {
            opacity: 0.8;
        }

        .actions .edit:hover {
            opacity: 0.8;
        }

        .menu-container {
            padding: 20px;
            border-radius: 8px; /* Bo góc cho viền */
            background-color: #fff; /* Màu nền nhẹ */
            margin: 20px auto; /* Canh giữa và tạo khoảng cách */
            box-shadow: 4px 8px 20px rgba(210, 180, 140, 0.9);
        }

        .menu-container h3 {
            font-size: 24px;
            color: #6F4E37;
        }

        .menu-container hr {
            border: 0;
            border-top: 2px solid #6B3E2F; /* Màu nâu cho đường kẻ */
            margin: 20px -20px; /* Khoảng cách từ đường kẻ đến các phần tử */
        }

        /* Định dạng phần filters */
        .filters {
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
            padding: 10px 0;
        }

        .filters select {
            width: 150px;
            padding: 8px;
            border-radius: 5px;
            border: 1px solid #ddd;
            font-size: 16px;
            color: #6F4E37;
            background-color: #fff;
            cursor: pointer;
        }

        .filters select:focus {
            outline: none;
            border-color: #6F4E37;
        }

        .filters label {
            color: #6F4E37;
            font-size: 16px;
            margin-right: 5px;
        }

        .filters input[type="date"] {
            width: 150px;
            padding: 8px;
            border-radius: 5px;
            border: 1px solid #ddd;
            font-size: 16px;
            color: #6F4E37;
        }

        .filters input[type="date"]::-webkit-calendar-picker-indicator {
            cursor: pointer;
            filter: invert(40%) sepia(50%) saturate(500%) hue-rotate(350deg) brightness(90%) contrast(90%);
        }

        .filters input[type="date"]:focus {
            outline: none;
            border-color: #6F4E37;
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
