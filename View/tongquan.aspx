<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="tongquan.aspx.cs" Inherits="BTL.View.tongquan" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <title>Tổng quan</title>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
<style>
    body {
        font-family: 'Roboto', sans-serif;
        display: flex;
        margin: 0;
        padding: 0;
        height: 100vh;
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


    /* Main content */
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
        margin-right: 20px;
    }

        .header h1 {
            margin: 0;
            font-size: 24px;
            color: #6F4E37;
        }

        .header .notification {
            font-size: 20px;
            color: #6F4E37;
        }

    .info-cards {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 20px;
        margin-top: 30px;
    }

    .card {
        background-color: #FFF;
        border-radius: 10px;
        padding: 50px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        text-align: center;
    }

        .card h3 {
            font-size: 18px;
            color: #6F4F28;
        }

        .card p {
            font-size: 22px;
            font-weight: bold;
            color: #D36D2F;
        }
</style>
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

    <!-- Main content -->
    <div class="main-content">
        <div class="header">
            <h1>Tổng quan</h1>
            <div class="notification"><i class="fa-regular fa-bell"></i></div>
        </div>

        <div class="info-cards">
            <div class="card">
                <h3>Doanh thu</h3>
                <p>4,000,000 đ</p>
            </div>
            <div class="card">
                <h3>Lợi nhuận</h3>
                <p>3,000,000 đ</p>
            </div>
            <div class="card">
                <h3>Nhân viên</h3>
                <p>3</p>
            </div>
            <div class="card">
                <h3>Tổng đơn hàng</h3>
                <p>79</p>
            </div>
        </div>
    </div>
</form>
<script>
    function toggleSubMenu(event) {
        event.stopPropagation();
        var submenu = document.getElementById("submenu");
        var icon = document.getElementById("icon");

        if (submenu.style.display === "none" || submenu.style.display === "") {
            submenu.style.display = "flex";
            icon.classList.add("rotate-down");
        } else {
            submenu.style.display = "none";
            icon.classList.remove("rotate-down");
        }
    }
</script>
</body>
</html>