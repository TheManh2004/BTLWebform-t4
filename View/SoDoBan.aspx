<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SoDoBan.aspx.cs" Inherits="BTL.View.SoDoBan" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sơ đồ bàn</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="../Style/StyleSoDoBan.css" />
</head>
<body>
    <form id="form1" runat="server" style="display: flex;">
        <!-- Hidden Field to Store Current Floor -->
        <asp:HiddenField ID="hdnCurrentFloor" runat="server" Value="1" ClientIDMode="Static" />

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
            <a href="DoanhThu.aspx">Thống kê doanh thu</a>
            <a href="DonHang.aspx">Quản lý đơn hàng</a>
            <a href="qlNV.aspx">Quản lý nhân viên</a>
            <a href="NguyenLieu.aspx">Quản Lý nguyên liệu</a>
            <a href="TTCaNhan.aspx">Thông tin cá nhân</a>
            <asp:Button ID="BtnLogout" runat="server" Text="Đăng xuất" class="btnlogout" OnClick="BtnLogout_Click" />
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <h1>Sơ đồ bàn</h1>
                <div class="notification"><i class="fa-regular fa-bell"></i></div>
            </div>

            <div class="floor-tabs" id="floorTabs" runat="server">
                <div id="floorButtons" runat="server">
                    <asp:Button ID="btnFloor1" CssClass="btn-floor active" runat="server" Text="Tầng 1" OnClick="btnFloor_Click" CommandArgument="1" />
                    <asp:Button ID="btnFloor2" CssClass="btn-floor" runat="server" Text="Tầng 2" OnClick="btnFloor_Click" CommandArgument="2" />
                    <asp:Button ID="btnFloor3" CssClass="btn-floor" runat="server" Text="Tầng 3" OnClick="btnFloor_Click" CommandArgument="3" />
                </div>
                <asp:Button ID="btnAddArea" CssClass="btn-add" runat="server" Text="+ Thêm khu vực" OnClientClick="showAddAreaModal(); return false;" OnClick="btnAddArea_Click" />
            </div>
            <hr />
            <div class="table-container" id="tableContainer" runat="server">
                <asp:Button ID="btnAddTable" runat="server" Text="+ Thêm bàn" CssClass="add-table" OnClientClick="showAddTableModal(document.getElementById('hdnCurrentFloor').value); return false;" OnClick="btnAddTable_Click" />
            </div>
        </div>

        <!-- Add Table Modal -->
        <div id="addTableModal" style="display:none;">
            <div class="modal-content">
                <div>
                    <h3>Thêm bàn</h3>
                    <span class="close" onclick="closeModal('addTableModal')">×</span>
                </div>
                <asp:HiddenField ID="hdnFloor" runat="server" ClientIDMode="Static" />
                <div>
                    <label>Tầng</label>
                    <asp:TextBox ID="txtFloor" runat="server" ReadOnly="true" ClientIDMode="Static" />
                </div>
                <div>
                    <label>Tên bàn</label>
                    <asp:TextBox ID="txtTableName" runat="server" ClientIDMode="Static" />
                </div>
                <div class="buttons">
                    <asp:Button ID="btnCloseModal" runat="server" Text="Đóng" OnClientClick="closeModal('addTableModal'); return false;" />
                    <asp:Button ID="btnSaveTable" runat="server" Text="Lưu" OnClick="btnSaveTable_Click" />
                </div>
            </div>
        </div>

        <!-- Add Area Modal -->
        <div id="addAreaModal" style="display:none;">
            <div class="modal-content">
                <span class="close" onclick="closeModal('addAreaModal')">×</span>
                <h3>Thêm khu vực</h3>
                <div>
                    <label>Tầng</label>
                    <asp:TextBox ID="txtNewFloorName" runat="server" ClientIDMode="Static" />
                </div>
                <div class="buttons">
                    <asp:Button ID="btnCloseAreaModal" runat="server" Text="Đóng" OnClientClick="closeModal('addAreaModal'); return false;" />
                    <asp:Button ID="btnSaveArea" runat="server" Text="Lưu" OnClick="btnSaveArea_Click" />
                </div>
            </div>
        </div>
    </form>

    <script src="../Scripts/ScriptsCode/SoDoBanJS.js">
       
    </script>

</body>
</html>