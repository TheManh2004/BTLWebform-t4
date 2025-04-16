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
        <!-- Hidden Fields to store the current floor and area ID -->
        <asp:HiddenField ID="hdnCurrentFloor" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hdnAreaId" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="hdnSelectedFloorId" runat="server" ClientIDMode="Static" Value="0" />

        <!-- Sidebar -->
        <div class="sidebar">
            <h2>MENU</h2>
            <a href="BanHang.aspx">Bán hàng</a>
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
            <asp:Button ID="BtnLogout" runat="server" Text="Đăng xuất" CssClass="btnlogout" OnClick="btnLogout_Click" />
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <h1>Sơ đồ bàn</h1>
                <div class="notification"><i class="fa-regular fa-bell"></i></div>
            </div>

            <!-- Floor Tabs (Dynamically Loaded) -->
            <div class="floor-tabs" id="floorTabs" runat="server">
                <div id="floorButtons" runat="server">
                    
                    <asp:Repeater ID="floorButtonsRepeater" runat="server">
                        <ItemTemplate>
                            <asp:Button ID="btnFloor" runat="server" 
                                        CssClass='<%# Eval("Area_id").ToString() == hdnSelectedFloorId.Value ? "btn-floor active" : "btn-floor" %>' 
                                        Text='<%# Eval("AreaName") %>' 
                                        CommandArgument='<%# Eval("Area_id") %>' 
                                        OnClick="BtnFloor_Click" 
                                        OnClientClick='<%# "selectFloor(\"" + Eval("Area_id") + "\", \"" + Eval("AreaName").ToString().Replace("Tầng ", "").Trim() + "\"); return true;" %>' />
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <!-- Button to Add a New Area -->
                <asp:Button ID="btnAddArea" CssClass="btn-add" runat="server" Text="+ Thêm khu vực" 
                            OnClientClick="showAddAreaModal(); return false;" OnClick="btnAddArea_Click" />
            </div>

            <hr />

            <!-- Table Display -->
            <div class="table-container" id="tableContainer" runat="server">
                <div id="tableNamesContainer">
                    <asp:Repeater ID="repeaterTables" runat="server">
                        <ItemTemplate>
                            <div class="table-box">
                                <%# Eval("TableFood_name") %>
                                
                                
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <!-- Button to Add a New Table -->
                <asp:Button ID="btnAddTable" runat="server" Text="+ Thêm bàn" CssClass="add-table"
                            OnClientClick="showAddTableModal(document.getElementById('hdnCurrentFloor').value, document.getElementById('hdnAreaId').value); return false;"
                            OnClick="btnAddTable_Click" ClientIDMode="Static" />
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
                        <asp:TextBox ID="txtFloor" runat="server" ReadOnly="true" ClientIDMode="Static" />
                    </div>
                    <div>
                        <label>Tên bàn</label>
                        <asp:TextBox ID="txtTableName" runat="server" ClientIDMode="Static" />
                    </div>
                    <div class="buttons">
                        <asp:Button ID="btnCloseModal" runat="server" Text="Đóng"
                                    OnClientClick="closeModal('addTableModal'); return false;" />
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
                        <asp:TextBox ID="txtNewFloorName" runat="server" ClientIDMode="Static" placeholder="Nhập tên khu vực" />
                    </div>
                    <div class="buttons">
                        <asp:Button ID="btnCloseAreaModal" runat="server" Text="Đóng"
                                    OnClientClick="closeModal('addAreaModal'); return false;" />
                        <asp:Button ID="btnSaveArea" runat="server" Text="Lưu" OnClick="btnSaveArea_Click" />
                    </div>
                </div>
            </div>
        </div>
    </form>

    <!-- Client-Side Scripts -->
    <script src="../Scripts/ScriptsCode/SoDoBanJS.js">  </script>
        <script></script>
  
</body>
</html>