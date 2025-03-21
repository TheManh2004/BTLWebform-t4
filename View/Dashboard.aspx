<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="BTL.View.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="../Style/StyleDashboard.css"
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hdnActiveTab" runat="server" Value="table" ClientIDMode="Static" />
        <asp:HiddenField ID="hdnActiveCategory" runat="server" Value="all" ClientIDMode="Static" />
        <asp:HiddenField ID="hdnSelectedTable" runat="server" Value="" ClientIDMode="Static" />
        <asp:HiddenField ID="hdnPaymentMethod" runat="server" Value="" ClientIDMode="Static" />
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
                        <asp:Button ID="btnAll" runat="server" Text="Tất cả" CssClass="category-btn active" CommandArgument="all" OnClientClick="setActiveCategory('all'); return false;" ClientIDMode="Static" />
                        <asp:Button ID="btnCoffee" runat="server" Text="Café" CssClass="category-btn" CommandArgument="coffee" OnClientClick="setActiveCategory('coffee'); return false;" ClientIDMode="Static" />
                        <asp:Button ID="btnTea" runat="server" Text="Trà" CssClass="category-btn" CommandArgument="tea" OnClientClick="setActiveCategory('tea'); return false;" ClientIDMode="Static" />
                    </div>
                    <div class="product-items-container" id="productItems" runat="server">
                        <asp:Repeater ID="rptProducts" runat="server">
                            <ItemTemplate>
                                <div class="product-item" onclick="addToCart('<%# Eval("Name") %>', <%# Eval("Price") %>)">
                                    <img src='<%# Eval("ImageUrl") %>' alt="Product" />
                                    <div class="name"><%# Eval("Name") %></div>
                                    <div class="price"><%# Eval("Price", "{0:N0} đ") %></div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>

                <!-- Floor Button Container -->
                <div class="floor-btn-container" id="floorBtnContainer" runat="server">
                    <asp:Button ID="btnNew" runat="server" CssClass="floor-btn" Text="Đang mới" OnClientClick="loadTables('new'); return false;" ClientIDMode="Static" />
                    <asp:Button ID="btnFloor1" runat="server" CssClass="floor-btn" Text="Tầng 1" OnClientClick="loadTables('floor1'); return false;" ClientIDMode="Static" />
                    <asp:Button ID="btnFloor2" runat="server" CssClass="floor-btn" Text="Tầng 2" OnClientClick="loadTables('floor2'); return false;" ClientIDMode="Static" />
                </div>
                <div class="table-items-container" id="tableItems" runat="server">
                    <asp:Repeater ID="rptTables" runat="server">
                        <ItemTemplate>
                            <div class="table-item" id="tableItem_<%# Eval("TableId") %>" onclick="selectTable('<%# Eval("TableId") %>', '<%# Eval("TableName") %>', '<%# Eval("Floor") %>', '<%# Eval("Status") %>', '<%# Eval("CustomerCount") != null ? Eval("CustomerCount") : "0" %>')">
                                <asp:Label ID="lblTableTitle" runat="server" CssClass="table-title" Text="MAT-C COFFE" />
                                <asp:Label ID="lblTableName" runat="server" CssClass="table-name" Text='<%# "Bàn " + Eval("TableName") %>' />
                                <asp:Label ID="lblStatus" runat="server" CssClass="table-status" Text='<%# !string.IsNullOrEmpty(Eval("Status").ToString()) ? Eval("Status") + " phút" : "" %>' Visible='<%# !string.IsNullOrEmpty(Eval("Status").ToString()) %>' />
                                <div class="table-icon"><%# Eval("CustomerCount") != null && Convert.ToInt32(Eval("CustomerCount")) > 0 ? Eval("CustomerCount") : "" %></div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Label ID="lblEmpty" runat="server" CssClass="empty-message" Text="Trống" Visible="false" />
                </div>
            </div>
            <div class="cart-section">
                <div class="cart-header">
                    <asp:TextBox ID="txtTablePosition" runat="server" CssClass="table-position" ReadOnly="true" Text="Chưa chọn bàn" ClientIDMode="Static" />
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="search-box" placeholder="Tìm kiếm" ClientIDMode="Static" />
                </div>
                <div class="cart-header">
                    <label for="txtCustomerCount" style="font-size: 16px; color: #333; font-weight: 500; margin-right: 10px;">Số khách:</label>
                    <input type="number" id="txtCustomerCount" min="0" value="0" style="padding: 10px; width: 100px; border: 2px solid #ddd; border-radius: 6px; font-size: 16px;" onchange="updateCustomerCount()" />
                </div>
                <div class="empty-cart-message" id="emptyCartMessage">Không có sản phẩm nào trong đơn</div>
                <div class="cart-items-wrapper" id="cartItems" runat="server"></div>
                <div class="cart-item summary">
                    <label>Tạm tính (<span id="cartItemCount">0</span> món)</label>
                    <asp:TextBox ID="txtSubtotal" runat="server" CssClass="summary-input" ReadOnly="true" Text="0 đ" ClientIDMode="Static" />
                </div>
                <div class="cart-item summary">
                    <label>Thuế hóa đơn</label>
                    <asp:TextBox ID="txtTax" runat="server" CssClass="summary-input" ReadOnly="true" Text="0 đ" ClientIDMode="Static" />
                </div>
                <div class="cart-item summary">
                    <label>Thành tiền</label>
                    <asp:TextBox ID="txtTotal" runat="server" CssClass="summary-input" ReadOnly="true" Text="0 đ" ClientIDMode="Static" />
                </div>
                <div class="cart-buttons">
                    <div class="menu-icon-btn">
                        <i class="fas fa-bars" onclick="toggleCartMenu()"></i>
                        <asp:Button ID="btnSave" runat="server" CssClass="btn btn-save" Text="Lưu" OnClientClick="syncCartWithServer(); return false;" ClientIDMode="Static" />
                        <div class="cart-dropdown-menu" id="cartDropdownMenu">
                            <div class="cart-dropdown-item" onclick="discount()">Giảm giá</div>
                            <div class="cart-dropdown-item" onclick="transferTable()">Chuyển bàn</div>
                            <div class="cart-dropdown-item" onclick="mergeTable()">Gộp bàn</div>
                            <div class="cart-dropdown-item" onclick="splitTable()">Tách bàn</div>
                            <div class="cart-dropdown-item" onclick="returnOrder()">Trả hàng</div>
                            <div class="cart-dropdown-item" onclick="cancelOrder()">Hủy đơn hàng</div>
                        </div>
                    </div>
                    <asp:Button ID="btnPay" runat="server" CssClass="btn btn-pay" Text="Thanh toán" OnClientClick="showPaymentModal(); return false;" OnClick="btnPay_Click" ClientIDMode="Static" />
                </div>
            </div>
        </div>

        <!-- Payment Modal -->
        <div id="paymentModal" style="display:none;">
            <div class="modal-content">
                <span class="close" onclick="closePaymentModal()">×</span>
                <h3><asp:Label ID="lblOrderId" runat="server" Text="HD0002" /> <asp:Label ID="lblFloor" runat="server" Text="Tầng 1 - Tầng một" /></h3>
                <div class="modal-body">
                    <div class="left-column">
                        <div class="modal-row">
                            <label>Tạm tính</label>
                            <asp:TextBox ID="txtTempTotal" runat="server" CssClass="modal-input" ReadOnly="true" Text="0 đ" ClientIDMode="Static" />
                        </div>
                        <div class="modal-row discount-container">
                            <label>Giảm giá</label>
                            <asp:TextBox ID="txtDiscountPercent" runat="server" CssClass="modal-input" Text="0" ClientIDMode="Static" onchange="updatePaymentTotals()" /> %
                            <asp:TextBox ID="txtDiscountAmount" runat="server" CssClass="modal-input" Text="0 đ" ClientIDMode="Static" onchange="updatePaymentTotals()" />
                        </div>
                        <div class="modal-row tax-container">
                            <label>Thuế</label>
                            <asp:TextBox ID="txtTaxPercent" runat="server" CssClass="modal-input" Text="10" ClientIDMode="Static" onchange="updatePaymentTotals()" /> %
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
                        <div class="modal-row">
                            <label>Khách thanh toán</label>
                            <asp:TextBox ID="txtCustomerPayment" runat="server" CssClass="modal-input" Text="0 đ" ClientIDMode="Static" onchange="updatePaymentTotals()" />
                        </div>
                    </div>
                </div>
                <div class="modal-row total-row">
                    <label>Tổng tiền</label>
                    <span><asp:Label ID="lblTotalAmount" runat="server" Text="0 đ" /></span>
                </div>
                <div class="modal-row pay-button">
                    <asp:Button ID="btnConfirmPay" runat="server" Text="Thanh toán" OnClick="btnConfirmPay_Click" CssClass="btn btn-pay" ClientIDMode="Static" />
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
                    <select id="targetTable">
                        <option value="">Chọn bàn</option>
                    </select>
                </div>
                <div class="modal-row">
                    <button type="button" onclick="confirmTransferTable()">Xác nhận</button>
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
                    <button type="button" onclick="confirmSplitTable()">Xác nhận</button>
                </div>
            </div>
        </div>

        <!-- Modal Gộp bàn -->
        <div id="mergeTableModal" class="modal" style="display:none;">
            <div class="modal-content">
                <span class="close" onclick="document.getElementById('mergeTableModal').style.display='none'">×</span>
                <h3>Gộp bàn</h3>
                <div class="modal-row">
                    <label>Bàn hiện tại</label>
                    <input type="text" id="mergeCurrentTable" readonly="readonly" />
                </div>
                <div class="modal-row">
                    <label>Gộp với</label>
                    <select id="mergeTargetTable">
                        <option value="">Chọn bàn</option>
                    </select>
                </div>
                <div class="modal-row">
                    <button type="button" onclick="confirmMergeTable()">Xác nhận</button>
                </div>
            </div>
        </div>
    </form>

    <script src="../Scripts/ScriptsCode/DashboardJS.js">
       
    </script>
</body>
</html>