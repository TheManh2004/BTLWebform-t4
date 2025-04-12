<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BanHang.aspx.cs" Inherits="BTL.View.BanHang" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="../Style/StyleBanHang.css" />
</head>
<body>
        
    <form id="form1" runat="server">
           <asp:ScriptManager runat="server" />
        <asp:HiddenField ID="hdnActiveTab" runat="server" Value="table" ClientIDMode="Static" />
        <asp:HiddenField ID="hdnCartData" runat="server" Value=""  ClientIDMode="Static"/>
        <asp:HiddenField ID="hdnActiveCategory" runat="server" Value="all" ClientIDMode="Static" />
        <asp:HiddenField ID="hdnSelectedTable" runat="server" Value="" ClientIDMode="Static" />
       <asp:HiddenField ID="hdnTargetTable" runat="server" value="" ClientIDMode="Static" />
        <asp:HiddenField ID="hdnPaymentMethod" runat="server" Value="" ClientIDMode="Static" />
        <asp:Button ID="btnHiddenPostBack" runat="server" OnClick="btnHiddenPostBack_Click" Style="display:none;" />
        <div class="header">
            <span class="title">Bán hàng</span>
            <div class="menu-toggle-container">
                <i class="fas fa-bars" onclick="toggleHeaderMenu()"></i>
                <div class="dropdown-menu" id="headerDropdownMenu">
                    <div class="dropdown-item" onclick="goToHome()">Trang chủ</div>
                    <div class="dropdown-item logout-item">
                        <asp:Button ID="btnLogout" runat="server" Text="Đăng xuất" OnClick="btnLogout_Click" CssClass="logout-btn" ClientIDMode="Static" />
                    </div>
                </div>
            </div>
        </div>
        
        <div class="container">
            <div class="content-section">
                <a href="#" id="tableTab" class="nav-btn active" onclick="switchTab('table'); return false;">Phòng bàn</a>
                <a href="#" id="menuTab" class="nav-btn" onclick="switchTab('menu'); return false;">Thực đơn</a>
                <div class="divider"></div>

                <!-- Menu Container -->
                <div class="menu-container" id="menuContainer" runat="server" style="display: none;">
                  <div class="category-menu" id="categoryMenu">
                        <asp:Repeater ID="rptCategories" runat="server">
                            <ItemTemplate>
                               <button type="button" class="category-btn"
                                        data-category="<%# Eval("FoodCategory_id") %>">
                                        <%# Eval("FoodCategory_name") %>
                                    </button>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                  <div class="product-items-container" id="productItems" runat="server" style="display:flex">
                       <asp:Repeater ID="rptProducts" runat="server">
                            <ItemTemplate>
                               <div class="product-item"  data-id="<%# Eval("Food_id") %>" data-category="<%# Eval("idCategory") %>">
                                    <img src='<%# ResolveUrl(Eval("img").ToString()) %>' alt="Product" />
                                    <div class="name"><%# Eval("Food_name") %></div>
                                    <div class="price"><%# Eval("price", "{0:N0} đ") %></div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>

                <!-- Floor Button Container -->
                <div class="floor-btn-container" id="floorBtnContainer" runat="server">
                    <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
                      <asp:Repeater ID="rptFloors" runat="server">
                            <ItemTemplate>
                                <button type="button" class="floor-btn" 
                                    data-floor="<%# Eval("Area_id") %>"
                                    data-name='filterTables("<%# Eval("Area_id") %>")'>
                                    <%# Eval("AreaName") %> 
                                </button>
                            </ItemTemplate>
                        </asp:Repeater>
                </div>
                <div class="table-items-container" id="tableItems" runat="server">
                 <asp:Repeater ID="rptTables" runat="server">
                        <ItemTemplate>
                            <div class="table-item" 
                                 id="tableItem_<%# Eval("TableFood_id") %>" 
                                 data-floor="<%# Eval("idArea") %>"
                                 data-status="<%# Eval("status") %>"
                                 data-name="selectTable('<%# Eval("TableFood_id") %>', '<%# Eval("TableFood_name") %>', '<%# Eval("idArea") %>', '<%# Eval("status") %>')">
                                <asp:Label ID="lblTableTitle" runat="server" CssClass="table-title" Text="MAT-C COFFE" />
                                <asp:Label ID="lblTableName" runat="server" CssClass="table-name" Text='<%# "Bàn " + Eval("TableFood_name") %>' />                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Label ID="lblEmpty" runat="server" CssClass="empty-message" Text="Trống" Visible="false" />
                </div>
            </div>
            <div class="cart-section">
                <div class="cart-header">
                    <asp:TextBox ID="txtTablePosition" runat="server" CssClass="table-position" ReadOnly="true" Text="Chưa chọn bàn" ClientIDMode="Static" />     
                </div>
                <div class="empty-cart-message" id="emptyCartMessage">Không có sản phẩm nào trong đơn</div>
                <div class="cart-items-wrapper" id="cartItems" runat="server"></div>
                <div id="billContainer"></div>
                    <asp:Label ID="lblResult" runat="server" ForeColor="Red"></asp:Label>
                <div class="cart-item summary">
                    <label>Tạm tính (<span id="cartItemCount">0</span> món)</label>
                    <asp:TextBox ID="txtSubtotal" runat="server" CssClass="summary-input" ReadOnly="true" Text="0 đ" ClientIDMode="Static" />
                </div>
                <div class="cart-item summary">
                    <label>Thành tiền</label>
                    <asp:TextBox ID="txtTotal" runat="server" CssClass="summary-input" ReadOnly="true" Text="0 đ" ClientIDMode="Static" />
                </div>
                <div class="cart-buttons"> 
                      <div class="menu-icon-btn">
                        <i class="fas fa-bars" ></i>
                        <div class="cart-dropdown-menu" id="cartDropdownMenu">
                            <div class="cart-dropdown-item" onclick="transferTable()">Chuyển bàn</div>
                            <div class="cart-dropdown-item" onclick="mergeTable()">Gộp bàn</div>
                            <div class="cart-dropdown-item" onclick="splitTable()">Tách bàn</div>
                            <div class="cart-dropdown-item" onclick="returnOrder()">Trả hàng</div>
                            <div class="cart-dropdown-item" onclick="cancelOrder()">Hủy đơn hàng</div>
                        </div>
                    </div>
                    <asp:Button ID="btnSaveBill" runat="server" Text="Lưu Hóa Đơn"   CssClass="btn btn-save" OnClick="btnSaveBill_Click" />
                   
                    <asp:Button ID="btnConfirmPay" runat="server" Text="Thanh toán" CssClass="btn btn-pay" ClientIDMode="Static" />

                </div>
            </div>
        </div>
      <!-- Payment Modal -->
    <div id="paymentModal" style="display:none;">
        <div class="modal-content">
            <span class="close" onclick="closePaymentModal()">×</span>
            <h3> <asp:Label ID="lblfloor" runat="server" ClientIDMode="Static" /></h3>
            <div class="modal-body">
                <div class="left-column">
                    <div class="modal-row">
                        <label>Tạm tính</label>
                        <asp:TextBox ID="txtTempTotal" runat="server" CssClass="modal-input" ReadOnly="true" Text="0 đ" ClientIDMode="Static" />
                    </div>
                    <div class="modal-row discount-container">
                        <label>Giảm giá</label>
                            <asp:TextBox ID="txtDiscountPercent" runat="server" CssClass="modal-input" Text="0" ClientIDMode="Static" oninput="updatePaymentTotals()" /> %
                            <asp:TextBox ID="txtDiscountAmount" runat="server" CssClass="modal-input" Text="0 đ" ClientIDMode="Static" oninput="updatePaymentTotals()" />
                    </div>
                    <div class="modal-row tax-container">
                        <label>Thuế</label>
                            <asp:TextBox ID="txtTaxPercent" runat="server" CssClass="modal-input" Text="10" ClientIDMode="Static" oninput="updatePaymentTotals()" /> %
                            <asp:TextBox ID="txtTaxAmount" runat="server" CssClass="modal-input" ReadOnly="true" Text="0 đ" ClientIDMode="Static" />
                    </div>
                    <div class="modal-row">
                        <label>Thành tiền</label>
                       <asp:TextBox ID="txtFinalTotal" runat="server" CssClass="modal-input" ReadOnly="true" Text="0 đ" ClientIDMode="Static" />
                    </div>
                </div>
                <div class="vertical-divider"></div>
                <div class="right-column">
                    <div class="modal-row">
                        <label>Khách cần trả</label>
                        <asp:TextBox ID="txtCustomerPay" runat="server" CssClass="modal-input" ReadOnly="true" Text="0 đ" ClientIDMode="Static" />
                    </div>
                    <div class="modal-row payment-methods">
                        <button type="button" id="paymentCashBtn" onclick="selectPaymentMethod('cash')"><i class="fas fa-money-bill-wave"></i> Tiền mặt</button>
                        <button type="button" id="paymentTransferBtn" onclick="selectPaymentMethod('transfer')"><i class="fas fa-exchange-alt"></i> Chuyển khoản</button>
                    </div>
                   
                </div>
            </div>
           
            <div class="modal-row pay-button">
                <asp:Button ID="btnThanhToan" runat="server" Text="Thanh Toán" CssClass="btn btn-pay" OnClick="btnThanhToan_Click" />
            </div>
        </div>
    </div>


        <!-- Modal Chuyển bàn -->
        <div id="transferTableModal" class="modal" style="display:none;">
            <div class="modal-content">
                <span class="close" onclick="document.getElementById('transferTableModal').style.display='none'">×</span>
                <h3>Chuyển bàn</h3>
                <div class="modal-row">
                    <label>Bàn hiện tại</label>
                    <input type="text" id="currentTable" readonly="readonly" />
                </div>
                <div class="modal-row">
                    <label>Chuyển đến</label>
                    <asp:DropDownList ID="targetTable" runat="server">
                        <asp:ListItem Text="Chọn bàn" Value="" />
                        <%-- Các ListItem sẽ được lặp qua từ dữ liệu và hiển thị --%>
                    </asp:DropDownList>
                </div>
                <div class="modal-row">
                    <button id="btnConfirmTransfer">Xác nhận</button>
                    <asp:Button ID="btnUpdateTable" runat="server" Text="Cập nhật bàn" OnClick="btnUpdateTable_Click" />
                </div>
            </div>
        </div>

        <!-- Modal Tách bàn -->
        <div id="splitTableModal" class="modal" style="display:none;">
            <div class="modal-content">
                <span class="close" onclick="document.getElementById('splitTableModal').style.display='none'">×</span>
                <h3>Tách bàn</h3>
                <div class="modal-row">
                    <label>Bàn hiện tại</label>
                    <input type="text" id="splitCurrentTable" readonly="readonly" />
                </div>
                <div class="modal-row">
                    <label>Số khách tách</label>
                    <input type="number" id="splitCustomerCount" min="0" />
                </div>
                <div class="modal-row">
                    <label>Tách đến</label>
                    <select id="splitTargetTable">
                        <option value="">Chọn bàn</option>
                    </select>
                </div>
                <div class="modal-row">
                    <label>Sản phẩm</label>
                    <select id="splitItems" multiple="multiple"></select>
                </div>
                <div class="modal-row">
                    <button type="button">Xác nhận</button>
                </div>
            </div>
        </div>

    
    </form>

<script src="../Scripts/ScriptsCode/DashboardJS.js"></script>
    
   
</body>
</html>