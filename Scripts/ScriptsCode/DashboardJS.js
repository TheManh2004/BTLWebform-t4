function formatCurrency(amount) {
    return amount.toLocaleString('vi-VN', { maximumFractionDigits: 0 }) + " đ";
}

function selectTable(tableId, tableName, floor, status, customerCount) {
    var tables = document.getElementsByClassName("table-item");
    for (var i = 0; i < tables.length; i++) {
        tables[i].classList.remove("selected");
    }
    var selectedTable = document.getElementById("tableItem_" + tableId);
    selectedTable.classList.add("selected");
    document.getElementById("hdnSelectedTable").value = tableId;
    document.getElementById("txtTablePosition").value = "Bàn " + tableName + " - " + (floor === "floor1" ? "Tầng 1" : "Tầng 2");
    document.getElementById("txtCustomerCount").value = customerCount || 0;
    switchTab('menu'); // Chuyển sang tab "Thực đơn" khi chọn bàn
    updateCartDisplay(); // Cập nhật giỏ hàng ngay khi chọn bàn
}

function switchTab(tab) {
    // Cập nhật giá trị hidden field
    document.getElementById("hdnActiveTab").value = tab;

    // Lấy các phần tử tab
    var tableTab = document.getElementById("tableTab");
    var menuTab = document.getElementById("menuTab");

    // Lấy các phần tử nội dung
    var menuContainer = document.getElementById("menuContainer");
    var floorBtnContainer = document.getElementById("floorBtnContainer");
    var tableItems = document.getElementById("tableItems");
    var productItems = document.getElementById("productItems");
    var categoryMenu = document.getElementById("categoryMenu");

    // Xóa lớp active khỏi cả hai tab
    tableTab.classList.remove("active");
    menuTab.classList.remove("active");

    // Hiển thị nội dung và thêm lớp active dựa trên tab
    if (tab === "menu") {
        menuContainer.style.display = "flex";
        floorBtnContainer.style.display = "none";
        tableItems.style.display = "none";
        productItems.style.display = "grid";
        categoryMenu.style.display = "flex";
        menuTab.classList.add("active"); // Thêm active cho Thực đơn
        setActiveCategory(document.getElementById("hdnActiveCategory").value);
    } else if (tab === "table") {
        menuContainer.style.display = "none";
        floorBtnContainer.style.display = "flex";
        tableItems.style.display = "grid";
        productItems.style.display = "none";
        categoryMenu.style.display = "none";
        tableTab.classList.add("active"); // Thêm active cho Phòng bàn
        loadTables('new');
    }

    updateCartDisplay(); // Cập nhật giỏ hàng
}

function setActiveCategory(category) {
    document.getElementById("hdnActiveCategory").value = category;
    switchTab('menu');

    document.getElementById("btnAll").classList.toggle("active", category === "all");
    document.getElementById("btnCoffee").classList.toggle("active", category === "coffee");
    document.getElementById("btnTea").classList.toggle("active", category === "tea");

    $.ajax({
        type: "POST",
        url: "Dashboard.aspx/GetProductsByCategory",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ category: category }),
        dataType: "json",
        success: function (response) {
            var products = JSON.parse(response.d);
            var productItems = document.getElementById("productItems");
            productItems.innerHTML = products.map(p => `
                        <div class="product-item" onclick="addToCart('${p.Name}', ${p.Price})">
                            <img src="${p.ImageUrl}" alt="Product" />
                            <div class="name">${p.Name}</div>
                            <div class="price">${formatCurrency(p.Price)}</div>
                        </div>
                    `).join('');
        },
        error: function (xhr, status, error) {
            console.error("Lỗi khi tải sản phẩm:", xhr.responseText);
        }
    });
}

function loadTables(filter) {
    document.getElementById("hdnActiveTab").value = "table";
    switchTab('table');

    $.ajax({
        type: "POST",
        url: "Dashboard.aspx/GetTablesByFilter",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ filter: filter }),
        dataType: "json",
        success: function (response) {
            var tables = JSON.parse(response.d);
            var tableItems = document.getElementById("tableItems");
            tableItems.innerHTML = tables.map(t => `
                        <div class="table-item" id="tableItem_${t.TableId}" onclick="selectTable('${t.TableId}', '${t.TableName}', '${t.Floor}', '${t.Status}', '${t.CustomerCount || 0}')">
                            <span class="table-title">MAT-C COFFE</span>
                            <span class="table-name">Bàn ${t.TableName}</span>
                            ${t.Status ? `<span class="table-status">${t.Status} phút</span>` : ''}
                            <div class="table-icon">${t.CustomerCount > 0 ? t.CustomerCount : ''}</div>
                        </div>
                    `).join('');
            document.getElementById("lblEmpty").style.display = tables.length ? "none" : "block";
        },
        error: function (xhr, status, error) {
            console.error("Lỗi khi tải bàn:", xhr.responseText);
        }
    });
}

function addToCart(productName, price) {
    var selectedTableId = document.getElementById("hdnSelectedTable").value;
    if (!selectedTableId) {
        alert("Vui lòng chọn bàn trước!");
        return;
    }
    var cart = JSON.parse(sessionStorage.getItem('cart_' + selectedTableId) || '[]');
    var existingItem = cart.find(item => item.ProductName === productName);
    if (existingItem) {
        existingItem.Quantity += 1;
    } else {
        cart.push({ ProductName: productName, Price: price, Quantity: 1 });
    }
    sessionStorage.setItem('cart_' + selectedTableId, JSON.stringify(cart));
    updateCartDisplay();
    syncCartWithServer(); // Đồng bộ giỏ hàng với server
}

function updateCartDisplay() {
    var selectedTableId = document.getElementById("hdnSelectedTable").value;
    if (selectedTableId) {
        var cart = JSON.parse(sessionStorage.getItem('cart_' + selectedTableId) || '[]');
        var cartItemsHtml = '';
        cart.forEach((item, index) => {
            var itemTotal = item.Price * item.Quantity;
            cartItemsHtml += `
                        <div class='cart-item'>
                            <span class='index'>${index + 1}</span>
                            <div class='name-container'>
                                <span class='name'>${item.ProductName}${item.Note ? ' (' + item.Note + ')' : ''}</span>
                                <i class='fas fa-sticky-note note-icon' onclick='addNote(${index})'></i>
                            </div>
                            <span class='quantity'>${item.Quantity}</span>
                            <span class='total-price'>${formatCurrency(itemTotal)}</span>
                            <span class='unit-price'>${formatCurrency(item.Price)}</span>
                            <i class='fas fa-trash delete-icon' onclick='deleteCartItem(${index})'></i>
                        </div>`;
        });
        document.getElementById('cartItems').innerHTML = cartItemsHtml;
        document.getElementById('emptyCartMessage').style.display = cart.length ? 'none' : 'block';
        document.getElementById('cartItemCount').innerText = cart.length;
        var subtotal = cart.reduce((sum, item) => sum + (item.Price * item.Quantity), 0);
        var tax = subtotal * 0.1; // Thuế mặc định 10%
        var total = subtotal + tax;
        document.getElementById('txtSubtotal').value = formatCurrency(subtotal);
        document.getElementById('txtTax').value = formatCurrency(tax);
        document.getElementById('txtTotal').value = formatCurrency(total);
    } else {
        document.getElementById('cartItems').innerHTML = '';
        document.getElementById('emptyCartMessage').style.display = 'block';
        document.getElementById('cartItemCount').innerText = '0';
        document.getElementById('txtSubtotal').value = formatCurrency(0);
        document.getElementById('txtTax').value = formatCurrency(0);
        document.getElementById('txtTotal').value = formatCurrency(0);
    }
}

function syncCartWithServer() {
    var selectedTableId = document.getElementById("hdnSelectedTable").value;
    if (!selectedTableId) return;
    var cart = JSON.parse(sessionStorage.getItem('cart_' + selectedTableId) || '[]');
    $.ajax({
        type: "POST",
        url: "Dashboard.aspx/SyncCart",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ tableId: selectedTableId, cart: cart }),
        dataType: "json",
        success: function (response) {
            console.log("Giỏ hàng đã được đồng bộ với server");
        },
        error: function (xhr, status, error) {
            console.error("Lỗi khi đồng bộ giỏ hàng:", xhr.responseText);
        }
    });
}

function loadCartFromServer() {
    var selectedTableId = document.getElementById("hdnSelectedTable").value;
    if (!selectedTableId) return;
    $.ajax({
        type: "POST",
        url: "Dashboard.aspx/GetCart",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ tableId: selectedTableId }),
        dataType: "json",
        success: function (response) {
            var cart = JSON.parse(response.d);
            sessionStorage.setItem('cart_' + selectedTableId, JSON.stringify(cart));
            updateCartDisplay();
        },
        error: function (xhr, status, error) {
            console.error("Lỗi khi tải giỏ hàng:", xhr.responseText);
        }
    });
}

function deleteCartItem(index) {
    var selectedTableId = document.getElementById("hdnSelectedTable").value;
    if (!selectedTableId) return;
    var cart = JSON.parse(sessionStorage.getItem('cart_' + selectedTableId) || '[]');
    cart.splice(index, 1);
    sessionStorage.setItem('cart_' + selectedTableId, JSON.stringify(cart));
    updateCartDisplay();
    syncCartWithServer();
}

function updateCustomerCount() {
    var customerCount = parseInt(document.getElementById("txtCustomerCount").value) || 0;
    if (customerCount < 0) {
        document.getElementById("txtCustomerCount").value = 0;
    }
}

function addNote(index) {
    var selectedTableId = document.getElementById("hdnSelectedTable").value;
    if (!selectedTableId) return;
    var cart = JSON.parse(sessionStorage.getItem('cart_' + selectedTableId) || '[]');
    var note = prompt("Nhập ghi chú cho sản phẩm thứ " + (index + 1) + ":");
    if (note !== null) {
        cart[index].Note = note;
        sessionStorage.setItem('cart_' + selectedTableId, JSON.stringify(cart));
        updateCartDisplay();
        syncCartWithServer();
    }
}

function toggleHeaderMenu() {
    var menu = document.getElementById("headerDropdownMenu");
    menu.style.display = menu.style.display === "block" ? "none" : "block";
}

function toggleCartMenu() {
    var menu = document.getElementById("cartDropdownMenu");
    menu.style.display = menu.style.display === "block" ? "none" : "block";
}

function goToHome() {
    window.location.href = "tongquan.aspx";
}

function discount() {
    var selectedTableId = document.getElementById("hdnSelectedTable").value;
    if (!selectedTableId) {
        alert("Vui lòng chọn bàn trước!");
        return;
    }
    var discount = prompt("Nhập phần trăm giảm giá (0-100):", "0");
    if (discount !== null && !isNaN(discount) && discount >= 0 && discount <= 100) {
        alert("Đã áp dụng giảm giá " + discount + "%");
    } else {
        alert("Giảm giá không hợp lệ!");
    }
}

function transferTable() {
    var selectedTableId = document.getElementById("hdnSelectedTable").value;
    if (!selectedTableId) {
        alert("Vui lòng chọn bàn trước!");
        return;
    }
    document.getElementById("currentTable").value = document.getElementById("txtTablePosition").value;
    document.getElementById("transferTableModal").style.display = "flex";
}

function confirmTransferTable() {
    document.getElementById("transferTableModal").style.display = "none";
    alert("Chuyển bàn thành công (chưa triển khai logic server-side)");
}

function mergeTable() {
    var selectedTableId = document.getElementById("hdnSelectedTable").value;
    if (!selectedTableId) {
        alert("Vui lòng chọn bàn trước!");
        return;
    }
    document.getElementById("mergeCurrentTable").value = document.getElementById("txtTablePosition").value;
    document.getElementById("mergeTableModal").style.display = "flex";
}

function confirmMergeTable() {
    document.getElementById("mergeTableModal").style.display = "none";
    alert("Gộp bàn thành công (chưa triển khai logic server-side)");
}

function splitTable() {
    var selectedTableId = document.getElementById("hdnSelectedTable").value;
    if (!selectedTableId) {
        alert("Vui lòng chọn bàn trước!");
        return;
    }
    document.getElementById("splitCurrentTable").value = document.getElementById("txtTablePosition").value;
    document.getElementById("splitCustomerCount").value = document.getElementById("txtCustomerCount").value;
    document.getElementById("splitTableModal").style.display = "flex";
}

function confirmSplitTable() {
    document.getElementById("splitTableModal").style.display = "none";
    alert("Tách bàn thành công (chưa triển khai logic server-side)");
}

function returnOrder() {
    var selectedTableId = document.getElementById("hdnSelectedTable").value;
    if (!selectedTableId) {
        alert("Vui lòng chọn bàn trước!");
        return;
    }
    var index = prompt("Nhập chỉ số sản phẩm muốn trả (từ 0):");
    if (index !== null && !isNaN(index) && index >= 0) {
        deleteCartItem(index);
    } else {
        alert("Chỉ số không hợp lệ!");
    }
}

function cancelOrder() {
    var selectedTableId = document.getElementById("hdnSelectedTable").value;
    if (!selectedTableId) {
        alert("Vui lòng chọn bàn trước!");
        return;
    }
    if (confirm("Bạn có chắc muốn hủy đơn hàng?")) {
        sessionStorage.removeItem('cart_' + selectedTableId);
        updateCartDisplay();
        syncCartWithServer();
    }
}

function showPaymentModal() {
    var selectedTableId = document.getElementById("hdnSelectedTable").value;
    if (!selectedTableId) {
        alert("Vui lòng chọn bàn trước!");
        return;
    }
    updatePaymentTotals();
    document.getElementById("paymentModal").style.display = "flex";
}

function closePaymentModal() {
    document.getElementById("paymentModal").style.display = "none";
}

function selectPaymentMethod(method) {
    document.getElementById("paymentCashBtn").classList.toggle("selected", method === "cash");
    document.getElementById("paymentTransferBtn").classList.toggle("selected", method === "transfer");
    document.getElementById("hdnPaymentMethod").value = method;
}

function updatePaymentTotals() {
    var subtotal = parseFloat(document.getElementById("txtSubtotal").value.replace(" đ", "").replace(/,/g, "")) || 0;
    var discountPercent = parseFloat(document.getElementById("txtDiscountPercent").value) || 0;
    var discountAmount = parseFloat(document.getElementById("txtDiscountAmount").value.replace(" đ", "").replace(/,/g, "")) || 0;
    var taxPercent = parseFloat(document.getElementById("txtTaxPercent").value) || 0;

    var discount = discountAmount + (subtotal * discountPercent / 100);
    var taxableAmount = subtotal - discount;
    var tax = taxableAmount * taxPercent / 100;
    var total = taxableAmount + tax;

    document.getElementById("txtTempTotal").value = formatCurrency(subtotal);
    document.getElementById("txtTaxAmount").value = formatCurrency(tax);
    document.getElementById("txtFinalTotal").value = formatCurrency(total);
    document.getElementById("txtCustomerPay").value = formatCurrency(total);
    document.getElementById("lblTotalAmount").innerText = formatCurrency(total);
}

$(document).ready(function () {
    var activeTab = document.getElementById("hdnActiveTab").value;
    switchTab(activeTab); // Khởi tạo tab active khi load trang

    // Các code khác giữ nguyên
    loadCartFromServer();

    $(document).click(function (e) {
        var headerMenu = $("#headerDropdownMenu");
        var cartMenu = $("#cartDropdownMenu");
        if (!headerMenu.is(e.target) && headerMenu.has(e.target).length === 0 && !$(".fa-bars").is(e.target)) {
            headerMenu.hide();
        }
        if (!cartMenu.is(e.target) && cartMenu.has(e.target).length === 0 && !$(".menu-icon-btn .fa-bars").is(e.target)) {
            cartMenu.hide();
        }
    });
});