<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AnUong.aspx.cs" Inherits="BTL.View.AnUong" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Đồ uống/món ăn</title>
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

       .content {
           display: flex;
           /*          align-items: center;*/
           justify-content: space-between;
       }

       /*form-container*/
       .form-container {
           padding: 20px;
           border-radius: 8px;
           background-color: #fff;
           margin: 20px auto;
           box-shadow: 4px 8px 20px rgba(210, 180, 140, 0.9);
       }

       .form-container h3 {
           font-size: 24px;
           color: #6F4E37;
       }

       .form-container hr {
           border: 0;
           border-top: 2px solid #6B3E2F;
           margin: 20px -20px;
       }

       .content {
           display: flex;
           gap: 15px;
           flex-wrap: wrap;
           justify-content: space-between;
       }

       .content input,
       .content select {
           padding: 10px;
           border-radius: 5px;
           border: 1px solid #ddd;
           font-size: 16px;
           margin-bottom: 10px;
       }

       .btnCreate {
           background-color: #D2B48C;
           color: white;
           border: none;
           padding: 10px 20px;
           border-radius: 5px;
           cursor: pointer;
           font-size: 16px;
           width: 150px;
           margin: auto;
       }

       .btnCreate:hover {
           background-color: #8B5E3B;
       }

       .content-up{
           width: 100%;
           display: flex;
           align-items: center;
           justify-content: space-between;
       }

       .content-down {
           width: 100%;
           display: flex;
           align-items: center;
           justify-content: start;
           gap: 114px;
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

       .search {
           display: flex;
           align-items: center;
           justify-content: space-between;
       }

           .txtSearch {
               padding: 10px;
               border-radius: 5px;
               border: 1px solid #ddd;
               font-size: 16px;
               width: 300px;
           }

           .search select {
               padding: 10px;
               border-radius: 5px;
               border: 1px solid #ddd;
               font-size: 16px;
               width: 200px;
           }

           .btnSearch {
               background-color: #D2B48C; /* Màu nền của nút */
               color: white;
               border: none;
               padding: 10px 20px;
               border-radius: 5px;
               cursor: pointer;
               font-size: 16px;
               width: 200px;
               height: 40px;
           }

            .btnSearch:hover {
                background-color: #8B5E3B; /* Màu nền thay đổi khi hover */
            }
   </style>
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
