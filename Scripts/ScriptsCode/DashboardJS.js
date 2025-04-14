document.addEventListener("DOMContentLoaded", function () {
    console.log("🚀 DashboardJS initialized!");

    function syncStorage(key, data) {
        const jsonData = JSON.stringify(data);
        localStorage.setItem(key, jsonData);
        sessionStorage.setItem(key, jsonData);
    }

    function switchTab(tabName) {
        document.getElementById("hdnActiveTab").value = tabName;
        document.getElementById("floorBtnContainer").style.display = (tabName === "table") ? "block" : "none";
        document.getElementById("tableItems").style.display = (tabName === "table") ? "flex" : "none";
        document.getElementById("menuContainer").style.display = (tabName === "menu") ? "flex" : "none";
        document.getElementById("tableTab").classList.toggle("active", tabName === "table");
        document.getElementById("menuTab").classList.toggle("active", tabName === "menu");
    }
    switchTab("table");

    function safeParse(jsonString) {
        try { return JSON.parse(jsonString); } catch (e) { console.error("❌ JSON Error:", e); return null; }
    }

    function checkStorageLimit(storageType) {
        let total = Object.keys(storageType).reduce((acc, key) => acc + (storageType.getItem(key) || "").length, 0);
        console.log(`📦 ${storageType === localStorage ? "localStorage" : "sessionStorage"}: ${(total / 1024).toFixed(2)} KB`);
    }

    function updateHiddenCartData() {
        let hiddenInput = document.getElementById("hdnCartData");
        if (hiddenInput) {
            hiddenInput.value = sessionStorage.getItem("cartData") || "[]";
            console.log("✅ Cập nhật hdnCartData:", hiddenInput.value);
        }
    }
    // Hàm lọc bàn theo tầng
    function filterTables(floorId) {
        document.querySelectorAll(".table-item").forEach(table => {
            table.style.display = (table.getAttribute("data-floor") === floorId) ? "flex" : "none";
        });
        console.log(`📌 Hiển thị bàn thuộc tầng: ${floorId}`);
    }


    // Gán sự kiện click cho nút tầng
    document.querySelectorAll(".floor-btn").forEach(button => {
        button.addEventListener("click", function () {
            let floorId = this.getAttribute("data-floor");
            filterTables(floorId);
        });
    });
    // Hiển thị tầng mặc định (nếu cần)
    let defaultFloor = document.querySelector(".floor-btn")?.getAttribute("data-floor") || "1";
    filterTables(defaultFloor);
    // Hàm lọc món theo danh mục
    function filterProducts(categoryId) {
        document.querySelectorAll(".product-item").forEach(product => {
            if (categoryId === "all") {
                product.style.display = "block"; // Hiển thị tất cả món
            } else {
                product.style.display = (product.getAttribute("data-category") === categoryId) ? "block" : "none";
            }
        });
        console.log(`📌 Hiển thị món thuộc danh mục: ${categoryId}`);
    }

    // Gán sự kiện click cho nút danh mục
    document.querySelectorAll(".category-btn").forEach(button => {
        button.addEventListener("click", function () {
            let categoryId = this.getAttribute("data-category");
            filterProducts(categoryId);
        });
    });

    // Hiển thị tất cả món mặc định
    filterProducts("all");

    function loadSavedOrder() {
        let selectedTable = safeParse(sessionStorage.getItem("selectedTable"));
        if (!selectedTable) return;
        sessionStorage.setItem("cartData", localStorage.getItem(`order_${selectedTable.id}`) || "[]");
        updateHiddenCartData();
        updateCartUI();
    }

    document.querySelectorAll(".table-item").forEach(table => {
        table.addEventListener("click", function () {
            let tableId = this.id.split("_")[1];
            let tableName = this.querySelector(".table-name").textContent;
            let floorId = this.getAttribute("data-floor");

            sessionStorage.clear();
            syncStorage("selectedTable", { id: tableId, name: tableName, floor: floorId });

            document.getElementById("txtTablePosition").value = `${tableName} - Tầng ${floorId}`;
            document.getElementById("currentTable").value = `${tableName} - Tầng ${floorId}`;
            document.getElementById("lblfloor").innerText = `${tableName} - Tầng ${floorId}`;
            document.getElementById("hdnSelectedTable").value = tableId;
            loadSavedOrder();
            switchTab("menu");
        });
    });

    // Thêm sản phẩm vào giỏ hàng
    document.querySelectorAll(".product-item").forEach(item => {
        item.addEventListener("click", function () {
            let foodId = this.getAttribute("data-id");
            let name = this.querySelector(".name")?.textContent.trim();
            let price = parseFloat(this.querySelector(".price")?.textContent.replace(" đ", "").replace(",", ""));
            if (!name || isNaN(price)) return console.error("❌ Dữ liệu sản phẩm không hợp lệ!");

            let cart = safeParse(sessionStorage.getItem("cartData")) || [];
            let itemIndex = cart.findIndex(i => i.Food_id == foodId);
            itemIndex > -1 ? cart[itemIndex].quantity++ : cart.push({ Food_id: foodId, name, price, quantity: 1 });

            sessionStorage.setItem("cartData", JSON.stringify(cart));
            updateHiddenCartData();
            updateCartUI();
        });
    });

    // Cập nhật UI giỏ hàng
    function updateCartUI() {
        let cart = safeParse(sessionStorage.getItem("cartData")) || [];

        // Lưu hóa đơn vào localStorage
        let selectedTable = safeParse(sessionStorage.getItem("selectedTable"));
        if (selectedTable) {
            localStorage.setItem(`order_${selectedTable.id}`, JSON.stringify(cart));
        }

        let cartItemsContainer = document.getElementById("cartItems");
        cartItemsContainer.innerHTML = "";
        let subtotal = cart.reduce((sum, item) => sum + item.price * item.quantity, 0);

        cart.forEach((item, index) => {
            let div = document.createElement("div");
            div.classList.add("cart-item");
            div.innerHTML = `<span>${item.name} x${item.quantity} - ${item.price * item.quantity} đ</span>
                             <button class="remove-item" data-index="${index}">❌</button>`;
            cartItemsContainer.appendChild(div);
        });

        document.getElementById("cartItemCount").textContent = cart.length;
        document.getElementById("txtSubtotal").value = `${subtotal} đ`;
        document.getElementById("txtTotal").value = `${subtotal} đ`;
        document.getElementById("txtTempTotal").value = `${subtotal} đ`;
    }
    function updatePaymentTotals() {
        // 1. Lấy tổng tạm tính
        let tempTotalStr = document.getElementById("txtTempTotal").value.replace(/[^\d]/g, '');
        let tempTotal = parseFloat(tempTotalStr) || 0;

        // 2. Lấy % giảm giá và số tiền giảm giá
        let discountPercent = parseFloat(document.getElementById("txtDiscountPercent").value) || 0;
        let discountAmountInput = document.getElementById("txtDiscountAmount").value.replace(/[^\d]/g, '');
        let discountAmount = parseFloat(discountAmountInput) || (tempTotal * discountPercent / 100);

        // Nếu người dùng chỉnh % → tính lại số tiền
        if (document.activeElement.id === "txtDiscountPercent") {
            discountAmount = tempTotal * discountPercent / 100;
            document.getElementById("txtDiscountAmount").value = `${discountAmount.toLocaleString()} đ`;
        }

        // Nếu người dùng chỉnh tiền giảm → tính lại %
        if (document.activeElement.id === "txtDiscountAmount") {
            discountPercent = (discountAmount / tempTotal) * 100;
            document.getElementById("txtDiscountPercent").value = discountPercent.toFixed(1);
        }

        // 3. Tính tổng sau giảm giá
        let afterDiscount = tempTotal - discountAmount;

        // 4. Tính thuế
        let taxPercent = parseFloat(document.getElementById("txtTaxPercent").value) || 0;
        let taxAmount = afterDiscount * taxPercent / 100;
        document.getElementById("txtTaxAmount").value = `${taxAmount.toLocaleString()} đ`;

        // 5. Tổng cuối cùng
        let finalTotal = afterDiscount + taxAmount;
        document.getElementById("txtFinalTotal").value = `${finalTotal.toLocaleString()} đ`;
        document.getElementById("txtCustomerPay").value = `${finalTotal.toLocaleString()} đ`;
  
    }
    // Xóa hoặc giảm số lượng sản phẩm
    document.getElementById("cartItems").addEventListener("click", function (event) {
        if (event.target.classList.contains("remove-item")) {
            let cart = safeParse(sessionStorage.getItem("cartData")) || [];
            let index = event.target.getAttribute("data-index");
            if (cart[index].quantity > 1) {
                cart[index].quantity -= 1; // Giảm số lượng đi 1
            } else {
                cart.splice(index, 1); // Nếu số lượng = 1 thì xóa luôn
            }
            sessionStorage.setItem("cartData", JSON.stringify(cart));
            updateCartUI();
        }
    });
    function getFloorIdFromTable(tableId) {
        let tableOption = document.querySelector(`#tableItem_${tableId}`);
        return tableOption ? tableOption.getAttribute("data-floor") : "Không xác định";
    }
    document.getElementById("btnConfirmTransfer").addEventListener("click", function (event) {
        event.preventDefault(); // Chặn hành vi mặc định (nếu có)
        updateTargetTable();

        let targetTableId = document.getElementById("hdnTargetTable").value;
        if (!targetTableId) {
            alert("⚠️ Chưa chọn bàn cần chuyển đến!");
            return;
        }

        let targetTableName = document.getElementById("targetTable").selectedOptions[0]?.text || "";

        // Kiểm tra hàm getFloorIdFromTable có tồn tại không trước khi gọi
        let floorId = (typeof getFloorIdFromTable === "function") ? getFloorIdFromTable(targetTableId) : "Không xác định";

        sessionStorage.setItem("targetTable", JSON.stringify({
            id: targetTableId,
            name: targetTableName,
            floor: floorId
        }));

        console.log(`✅ Đã lưu vào sessionStorage: Bàn ${targetTableId} (${targetTableName}), Tầng: ${floorId}`);
        alert(`✅ Xác nhận chuyển bàn thành công!`);
    });


    function updateTargetTable() {         
        let targetTable = document.getElementById("targetTable");
        let targetTableId = targetTable.value;

        if (!targetTableId) {
            alert("⚠️ Vui lòng chọn bàn cần chuyển đến!");
            return;
        }

        document.getElementById("hdnTargetTable").value = targetTableId;
        console.log("✅ Đã cập nhật hdnTargetTable với ID bàn:", targetTableId);
    }
    document.getElementById("btnUpdateTable").addEventListener("click", function () {
        let currentTableId = document.getElementById("hdnSelectedTable").value;
        let targetTableId = document.getElementById("targetTable").value;
        let targetTableName = document.getElementById("targetTable").selectedOptions[0].text;
        let floorId = getFloorIdFromTable(targetTableId);

        console.log("🚀 Chuyển từ bàn:", currentTableId, "➡️", targetTableId);

        updateTargetTable(); // Cập nhật input ẩn `hdnTargetTable` với ID bàn mới

        // Kiểm tra bàn cần chuyển có hợp lệ không
        if (!targetTableId) {
            alert("⚠️ Vui lòng chọn bàn cần chuyển đến!");
            return;
        }

        // 🟢 Lấy dữ liệu hóa đơn từ bàn hiện tại
        let cartData = safeParse(localStorage.getItem(`order_${currentTableId}`)) || [];

        // 🛑 Kiểm tra dữ liệu có hợp lệ không trước khi tiếp tục
        if (cartData.length === 0) {
            alert("⚠️ Không có đơn hàng để chuyển!");
            return;
        }

        console.log("📦 Dữ liệu đơn hàng cần chuyển:", cartData);

        // 🛠️ Lưu giỏ hàng vào bàn mới trước khi xóa bàn cũ
        localStorage.setItem(`order_${targetTableId}`, JSON.stringify(cartData));

        // 🔄 Kiểm tra lại xem dữ liệu đã lưu chưa
        let newCartData = safeParse(localStorage.getItem(`order_${targetTableId}`));
        if (newCartData.length === 0) {
            alert("⚠️ Lỗi khi lưu dữ liệu giỏ hàng vào bàn mới!");
            return;
        }

        console.log("✅ Đã cập nhật giỏ hàng vào bàn mới:", newCartData);

        // 🗑 Xóa đơn hàng của bàn cũ
        localStorage.removeItem(`order_${currentTableId}`);

        // Gọi sự kiện C# để cập nhật trên server
        setTimeout(() => {
            document.getElementById("btnUpdateTable").click();
        }, 100); // Delay nhẹ để C# xử lý trước

        // 🟢 Sau khi C# cập nhật xong, mới cập nhật JavaScript
        setTimeout(() => {
            document.getElementById("hdnSelectedTable").value = targetTableId; // Cập nhật bàn mới

            syncStorage("selectedTable", { id: targetTableId, name: targetTableName, floor: floorId });

            updateCartUI(); // Cập nhật UI giỏ hàng ngay lập tức

            alert(`✅ Chuyển bàn thành công! ${currentTableId} ➝ ${targetTableId}`);
            document.getElementById("transferTableModal").style.display = "none"; // Đóng modal
        }, 500);
    });
   
    document.getElementById("btnSaveBill").addEventListener("click", function () {
        let cart = safeParse(sessionStorage.getItem("cartData")) || [];
        let selectedTable = safeParse(sessionStorage.getItem("selectedTable"));

        if (!selectedTable?.id || cart.length === 0) return alert("⚠️ Chọn bàn và thêm món trước khi lưu!");

        console.log("📦 Gửi dữ liệu:", cart, "📌 Bàn:", selectedTable);

        document.getElementById("hdnCartData").value = JSON.stringify(cart);
        document.getElementById("hdnSelectedTable").value = selectedTable.id;

        // Không chặn submit form
        document.getElementById("form1").submit();
    });



    document.getElementById('btnConfirmPay').addEventListener('click', function () {
        event.preventDefault(); // Ngăn chặn hành động submit của form
        openPaymentModal(); // Mở modal thanh toán
        updatePaymentTotals();
    });

    // Hàm mở modal thanh toán
    function openPaymentModal() {
        document.getElementById('paymentModal').style.display = 'block';
    }

    // Hàm đóng modal thanh toán
    function closePaymentModal() {
        document.getElementById('paymentModal').style.display = 'none';
    }

    // Gán sự kiện click cho nút thanh toán để mở modal
    document.getElementById('btnConfirmPay').addEventListener('click', function () {
        openPaymentModal();
    });

    // Đảm bảo đóng modal khi click vào dấu "×"
    document.querySelector('.close').addEventListener('click', function () {
        closePaymentModal();
    });

  
    const menuIcon = document.querySelector(".menu-icon-btn i");
    const cartDropdown = document.getElementById("cartDropdownMenu");

    // Ẩn menu ban đầu
    cartDropdown.style.display = "none";

    // Toggle hiển thị menu
    menuIcon.addEventListener("click", toggleCartDropdown);

    // Đóng menu khi click ra ngoài
    document.addEventListener("click", function (event) {
        if (!menuIcon.contains(event.target) && !cartDropdown.contains(event.target)) {
            cartDropdown.style.display = "none";
        }
    });

    // Hàm toggle hiển thị dropdown
    function toggleCartDropdown() {
        cartDropdown.style.display = (cartDropdown.style.display === "none") ? "block" : "none";
    }

    // Hàm hiển thị modal
    function showModal(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.style.display = "block";
        }
    }

    // Các chức năng mở modal
    const menuFunctions = {
        discount: "discountModal",
        transferTable: "transferTableModal",
        mergeTable: "mergeTableModal",
        splitTable: "splitTableModal",
        returnOrder: "returnOrderModal",
        cancelOrder: "cancelOrderModal"
    };

    // Gán sự kiện cho các nút menu
    Object.keys(menuFunctions).forEach(function (action) {
        window[action] = function () {
            showModal(menuFunctions[action]);
        };
    });
    function toggleHeaderMenu() {
        const dropdown = document.getElementById("headerDropdownMenu");
        // Kiểm tra nếu dropdown hiện đang ẩn
        if (dropdown.style.display === "none" || dropdown.style.display === "") {
            dropdown.style.display = "block"; // Hiển thị menu
        } else {
            dropdown.style.display = "none"; // Ẩn menu
        }
    }

    window.toggleHeaderMenu = toggleHeaderMenu; // Gắn hàm vào global scope


    // Hàm mở modal thanh toán
    // Hàm mở modal thanh toán
    checkStorageLimit(sessionStorage);
    checkStorageLimit(localStorage);
});
