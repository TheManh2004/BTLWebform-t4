<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DoAn-DoUong.aspx.cs" Inherits="BTL.View.AnUong" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Đồ uống/món ăn</title>
   <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
   <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../Style/StyleDoAn-DoUong.css" />
</head>
<body>
    <form id="form1" runat="server" style="display: flex; ">
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
    </asp:DropDownList>
    <!-- Thêm FileUpload để upload ảnh -->
    <asp:FileUpload ID="fileUploadImage" runat="server" style="width: 95px" />
    <!-- (Tuỳ chọn) Hiển thị ảnh đã upload để xem trước -->
    <asp:Image ID="imgPreview" runat="server" style="max-width: 100px; max-height: 100px; display: none;" />
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
                
                <asp:Button ID="btnSearch" class="btnSearch" runat="server" Text="Tìm kiếm" OnClick="btnSearch_Click" />
            </div>
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
    OnRowEditing="GridView1_RowEditing" 
    OnRowUpdating="GridView1_RowUpdating" 
    OnRowDeleting="GridView1_RowDeleting" 
    OnRowCancelingEdit="GridView1_RowCancelingEdit" 
    DataKeyNames="Food_id" 
    CssClass="table" 
    CellPadding="4" BorderColor="#CCCCCC" BorderStyle="Solid" BorderWidth="1px">
    <Columns>
        <asp:BoundField DataField="Food_id" HeaderText="STT" SortExpression="Food_id" />
        
        <asp:TemplateField HeaderText="Tên Món">
            <EditItemTemplate>
                <asp:TextBox ID="txtEditFoodCategoryName" runat="server" Text='<%# Bind("Food_name") %>' />
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="lblFoodCategoryName" runat="server" Text='<%# Bind("Food_name") %>' />
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Giá">
            <EditItemTemplate>
                <asp:TextBox ID="txtEditPrice" runat="server" Text='<%# Bind("Gia") %>' />
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="lblPrice" runat="server" Text='<%# Bind("Gia") %>' />
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Trạng Thái">
            <EditItemTemplate>
                <asp:DropDownList ID="ddlEditStatus" runat="server">
                    <asp:ListItem Text="Hoạt động" Value="active" />
                    <asp:ListItem Text="Ngừng hoạt động" Value="inactive" />
                </asp:DropDownList>
            </EditItemTemplate>
            <ItemTemplate>
                <asp:Label ID="lblStatus" runat="server" Text='<%# Bind("TrangThai") %>' />
            </ItemTemplate>
        </asp:TemplateField>

        <asp:BoundField DataField="DanhMuc" HeaderText="Danh Mục" SortExpression="DanhMuc" />
        <asp:BoundField DataField="DVT" HeaderText="Đơn Vị Tính" SortExpression="DVT" />
        <asp:TemplateField HeaderText="Ảnh">
            <ItemTemplate>
                <asp:Image ID="imgFood" runat="server" ImageUrl='<%# Eval("ImagePath") %>' 
                    style="max-width: 50px; max-height: 50px;" 
                    AlternateText="Không có ảnh" />
            </ItemTemplate>
        </asp:TemplateField>

        <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" />
    </Columns>
</asp:GridView>


        </div>
    </div>
    </form>
    <script src="../Scripts/ScriptsCode/AnUongJS.js">
   
    </script>

</body>
</html>