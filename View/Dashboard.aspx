<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="BTL.View.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* Giữ nguyên CSS của bạn */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            overflow: hidden;
            background-color: #f4f4f4;
        }

        /* Header */
        .header {
            background-color: #5C4033;
            color: #fff;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 10px 15px;
        }
        .header .title {
            font-size: 28px;
            font-weight: bold;
            margin-left: 12px;
        }
        .menu-toggle-container {
            position: relative;
        }
        .menu-toggle-container .fas {
            font-size: 28px;
            color: #fff;
            cursor: pointer;
            padding: 15px;
            transition: color 0.3s ease;
        }
        .menu-toggle-container .fas:hover {
            color: #ddd;
        }
        .dropdown-menu {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            width: 220px;
        }
        .dropdown-item {
            padding: 12px 20px;
            font-size: 16px;
            cursor: pointer;
            color: #333;
            transition: background-color 0.2s ease;
        }
        .dropdown-item:hover {
            background-color: #f5f5f5;
        }
        .logout-item {
            color: #ff0000;
        }
        .logout-item:hover {
            background-color: #f5f5f5;
        }
        .logout-btn {
            background: none;
            border: none;
            color: #ff0000;
            font-size: 16px;
            cursor: pointer;
            padding: 0;
            width: 100%;
            text-align: left;
        }

        /* Container chính */
        .container {
            display: flex;
            height: calc(100vh - 100px);
            gap: 30px;
            padding: 10px;
            background-color: #fff;
        }
        .content-section {
            width: 65%;
            padding: 12px;
            border-right: 2px solid #ddd;
            height: calc(100vh - 100px);
            box-sizing: border-box;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
       .nav-btn {
    color: #5C4033;
    text-decoration: none;
    cursor: pointer;
    padding: 15px 25px;
    position: relative;
    transition: all 0.3s ease;
    border-radius: 6px;
    display: inline-block;
    margin-right: 25px;
}

.nav-btn:hover {
    background-color: #f5f5f5;
}

.nav-btn.active {
    color: #8B4513;
    font-weight: bold;
    background-color: #f0e8e0; /* Ô vuông */
}

.nav-btn.active::after {
    content: '';
    position: absolute;
    bottom: -10px;
    left: 50%;
    transform: translateX(-50%);
    width: 60%;
    height: 4px;
    background-color: #8B4513; /* Đường kẻ */
}
        .divider {
            border-top: 2px solid #ddd;
            margin: 25px 0;
        }

        /* Menu và sản phẩm */
        .menu-container {
            display: flex;
            height: calc(100% - 90px);
        }
        .category-menu {
            width: 15%;
            background-color: #fff;
            padding: 15px;
            border-right: 2px solid #ddd;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .category-menu button {
            display: block;
            width: 100%;
            padding: 16px 25px;
            margin: 0;
            border: 2px solid #ddd;
            background-color: #f9f9f9;
            text-align: left;
            font-size: 22px;
            font-weight: 500;
            color: #5C4033;
            cursor: pointer;
            border-radius: 10px;
            box-sizing: border-box;
            transition: all 0.3s ease;
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.1);
        }
        .category-menu button:hover {
            background-color: #f0f0f0;
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
            transform: translateY(-3px);
        }
        .category-menu button.active {
            background-color: #D2B48C;
            color: #fff;
            border-color: #D2B48C;
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.2);
            transform: translateY(2px);
        }
        .product-items-container, .table-items-container {
            display: none;
            grid-template-columns: repeat(6, 1fr);
            gap: 8px;
            max-height: calc(100vh - 220px);
            overflow-y: auto;
            padding: 15px;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        }
        .product-items-container {
            width: 85%;
        }
        .product-item {
            text-align: center;
            border: 2px solid #e0e0e0;
            padding: 10px;
            background-color: #fff;
            width: 140px;
            height: 200px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            align-items: center;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s ease;
            cursor: pointer;
        }
        .product-item:hover {
            transform: scale(1.05);
        }
        .product-item img {
            width: 100%;
            height: 120px;
            object-fit: cover;
            border-radius: 6px;
        }
        .product-item .name {
            font-size: 14px;
            margin: 5px 0;
            color: #333;
            font-weight: 500;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            width: 100%;
        }
        .product-item .price {
            color: #8B4513;
            font-weight: bold;
            font-size: 16px;
        }
        .floor-btn-container {
            display: none;
            gap: 15px;
            margin: 15px 0;
        }
        .floor-btn {
            padding: 10px 20px;
            border: 2px solid #ddd;
            background-color: #fff;
            cursor: pointer;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .floor-btn:hover {
            background-color: #f0f0f0;
            border-color: #ccc;
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.1);
        }
        .table-item {
            text-align: center;
            background-color: #F5E8C7;
            border: 2px solid #8B4513;
            border-radius: 8px;
            width: 140px;
            height: 160px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            align-items: center;
            position: relative;
            box-sizing: border-box;
            padding: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            transition: transform 0.2s ease;
            cursor: pointer;
        }
        .table-item:hover {
            transform: scale(1.05);
        }
        .table-item::before {
            content: '';
            position: absolute;
            top: 50px;
            left: 10px;
            right: 10px;
            border-top: 2px solid #8B4513;
        }
        .table-item .table-title {
            font-size: 14px;
            font-weight: bold;
            color: #8B4513;
            margin-bottom: 5px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            width: 100%;
        }
        .table-item .table-name {
            font-size: 20px;
            font-weight: bold;
            color: #8B4513;
            margin: 5px 0;
            flex-grow: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            width: 100%;
            text-align: center;
        }
        .table-item .table-status {
            font-size: 12px;
            color: #8B4513;
            position: absolute;
            bottom: 10px;
            left: 10px;
        }
        .table-item .table-icon {
            position: absolute;
            bottom: 10px;
            right: 10px;
            width: 24px;
            height: 24px;
            background-color: #D3D3D3;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: #fff;
            font-weight: bold;
        }
        .table-item.selected {
            background-color: #D2B48C;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        /* Cart Section */
        .cart-section {
            width: 35%;
            padding: 15px;
            background-color: #fff;
            height: calc(100vh - 100px);
            box-sizing: border-box;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
        }
        .cart-header {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        .table-position {
            padding: 15px 10px;
            border: 2px solid #ddd;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 16px;
            background-color: #fff;
            color: #333;
            width: 100%;
            text-align: center;
            font-weight: 500;
            max-width: 100%;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }
        .search-box {
            padding: 15px 10px;
            width: 100%;
            border: 2px solid #ddd;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 16px;
            background-color: #fff;
            max-width: 100%;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }
        .empty-cart-message {
            color: #888;
            font-size: 16px;
            text-align: center;
            margin: 20px 0;
            display: none;
        }
        .cart-items-wrapper {
            flex-grow: 1;
            max-height: 40vh;
            overflow-y: auto;
            margin-bottom: 20px;
            padding-right: 5px;
        }
        .cart-items-wrapper::-webkit-scrollbar {
            width: 8px;
        }
        .cart-items-wrapper::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 4px;
        }
        .cart-items-wrapper::-webkit-scrollbar-thumb {
            background: #D2B48C;
            border-radius: 4px;
        }
        .cart-items-wrapper::-webkit-scrollbar-thumb:hover {
            background: #b89c73;
        }
        .cart-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
            padding: 10px;
            background-color: #FFF8DC;
            border-radius: 6px;
            border: 1px solid #ddd;
            position: relative;
        }
        .cart-item.summary {
            background-color: transparent;
            border: none;
            padding: 10px 0;
            margin-bottom: 10px;
        }
        .cart-item .index {
            width: 5%;
            font-size: 16px;
            color: #333;
        }
        .cart-item .name-container {
            width: 30%;
            display: flex;
            align-items: center;
        }
        .cart-item .name {
            font-size: 16px;
            color: #333;
            font-weight: 500;
            margin-right: 10px;
        }
        .cart-item .note-icon {
            font-size: 16px;
            color: #666;
            cursor: pointer;
            transition: color 0.2s ease;
        }
        .cart-item .note-icon:hover {
            color: #333;
        }
        .cart-item .quantity {
            width: 10%;
            font-size: 16px;
            color: #333;
            text-align: center;
        }
        .cart-item .total-price {
            width: 20%;
            font-size: 16px;
            color: #8B4513;
            font-weight: bold;
            text-align: right;
        }
        .cart-item .unit-price {
            width: 20%;
            font-size: 14px;
            color: #666;
            text-align: right;
        }
        .cart-item .delete-icon {
            width: 5%;
            font-size: 16px;
            color: #ff0000;
            cursor: pointer;
            text-align: center;
            transition: color 0.2s ease;
        }
        .cart-item .delete-icon:hover {
            color: #cc0000;
        }
        .cart-item label {
            display: block;
            margin-bottom: 10px;
            font-size: 16px;
            color: #333;
            font-weight: 500;
        }
        .cart-item input {
            padding: 15px 10px;
            border: 2px solid #ddd;
            border-radius: 6px;
            background-color: #FFF8DC;
            box-sizing: border-box;
            font-size: 16px;
            text-align: right;
            max-width: 100%;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }
        .cart-buttons {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }
        .menu-icon-btn {
            position: relative;
            display: flex;
            align-items: center;
            gap: 15px;
            width: 100%;
        }
        .menu-icon-btn .fas {
            font-size: 20px;
            color: #fff;
            cursor: pointer;
            padding: 15px;
            background-color: #D2B48C;
            border-radius: 6px 0 0 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background-color 0.3s ease;
        }
        .menu-icon-btn .fas:hover {
            background-color: #b89c73;
        }
        .menu-icon-btn .btn-save {
            border-radius: 0 6px 6px 0;
            margin: 0;
            flex-grow: 1;
        }
        .cart-dropdown-menu {
            display: none;
            position: absolute;
            bottom: 70px;
            left: 0;
            background-color: #fff;
            border: 2px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            width: 220px;
        }
        .cart-dropdown-item {
            padding: 12px 20px;
            font-size: 16px;
            cursor: pointer;
            color: #333;
            transition: background-color 0.2s ease;
        }
        .cart-dropdown-item:hover {
            background-color: #f5f5f5;
        }
        .btn {
            padding: 15px 30px;
            border: none;
            cursor: pointer;
            width: 100%;
            border-radius: 6px;
            font-size: 16px;
            transition: background-color 0.3s ease;
            text-align: center;
            color: #fff;
        }
        .btn-save {
            background-color: #D2B48C;
        }
        .btn-save:hover {
            background-color: #b89c73;
        }
        .btn-pay {
            background-color: #5C4033;
        }
        .btn-pay:hover {
            background-color: #3e2b20;
        }
        .empty-message {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 28px;
            color: #888;
            text-align: center;
            font-style: italic;
        }

        /* Payment Modal Styles */
        #paymentModal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            justify-content: center;
            align-items: center;
            z-index: 10000;
            animation: fadeIn 0.3s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        #paymentModal .modal-content {
            background: linear-gradient(145deg, #FFF8DC, #F5E8C7);
            padding: 40px;
            border-radius: 16px;
            max-width: 1200px;
            width: 90%;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            position: relative;
            display: flex;
            flex-direction: column;
            border: 1px solid #D2B48C;
            animation: slideUp 0.3s ease-out;
        }
        @keyframes slideUp {
            from { transform: translateY(20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        .modal-content .close {
            position: absolute;
            top: 20px;
            right: 20px;
            font-size: 36px;
            cursor: pointer;
            color: #5C4033;
            transition: color 0.3s ease, transform 0.3s ease;
        }
        .modal-content .close:hover {
            color: #8B4513;
            transform: rotate(90deg);
        }
        .modal-content h3 {
            margin: 0 0 30px;
            font-size: 32px;
            color: #5C4033;
            text-align: center;
            border-bottom: 3px solid #8B4513;
            padding-bottom: 15px;
            font-weight: 600;
            letter-spacing: 1px;
        }
        .modal-content .modal-body {
            display: flex;
            justify-content: space-between;
            flex-grow: 1;
        }
        .modal-content .left-column,
        .modal-content .right-column {
            width: 45%;
            padding: 25px;
            background: #fff;
            border-radius: 12px;
            box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.05);
        }
        .modal-content .modal-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            gap: 25px;
            padding: 12px 0;
            border-bottom: 1px dashed #ddd;
        }
        .modal-content .modal-row:last-child {
            border-bottom: none;
        }
        .modal-content .modal-row label {
            font-weight: 600;
            color: #5C4033;
            margin-right: 20px;
            width: 150px;
            font-size: 18px;
            letter-spacing: 0.5px;
        }
        .modal-content .modal-row input[type="text"],
        .modal-content .modal-row input[type="number"] {
            padding: 14px 10px;
            border: 2px solid #D2B48C;
            border-radius: 6px;
            width: 200px;
            text-align: right;
            background-color: #fff;
            font-size: 18px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
            font-weight: 500;
            color: #333;
            max-width: 100%;
            box-sizing: border-box;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }
        .modal-content .modal-row input[type="text"]:focus,
        .modal-content .modal-row input[type="number"]:focus {
            border-color: #8B4513;
            box-shadow: 0 0 8px rgba(139, 69, 19, 0.2);
            outline: none;
        }
        .modal-content .modal-row .discount-container,
        .modal-content .modal-row .tax-container {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .modal-content .modal-row .discount-container input[type="number"],
        .modal-content .modal-row .tax-container input[type="number"] {
            width: 90px;
            margin-right: 15px;
            font-size: 18px;
            border-color: #D2B48C;
            max-width: 100%;
            box-sizing: border-box;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }
        .modal-content .modal-row .payment-methods {
            display: flex;
            gap: 50px;
            justify-content: center;
            margin: 25px 0;
        }
        .modal-content .modal-row .payment-methods button,
        #paymentCashBtn,
        #paymentTransferBtn {
            padding: 15px 40px;
            border: 2px solid #D2B48C;
            border-radius: 10px;
            cursor: pointer;
            background: linear-gradient(145deg, #FFF8DC, #F5E8C7);
            color: #5C4033;
            font-size: 18px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 12px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        .modal-content .modal-row .payment-methods button:hover,
        #paymentCashBtn:hover,
        #paymentTransferBtn:hover {
            background: linear-gradient(145deg, #D2B48C, #b89c73);
            color: #fff;
            border-color: #8B4513;
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
        }
        .modal-content .modal-row .payment-methods button.selected,
        #paymentCashBtn.selected,
        #paymentTransferBtn.selected {
            background: linear-gradient(145deg, #5C4033, #8B4513);
            color: #fff;
            border-color: #8B4513;
            transform: translateY(0);
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.2);
        }
        .modal-content .modal-row .payment-methods button i {
            font-size: 24px;
            transition: transform 0.3s ease;
        }
        .modal-content .modal-row .payment-methods button:hover i {
            transform: scale(1.2);
        }
        .modal-content .modal-row .total-row {
            font-weight: bold;
            font-size: 26px;
            background: linear-gradient(90deg, #5C4033, #8B4513);
            color: #fff;
            padding: 20px;
            border-radius: 12px;
            width: 100%;
            text-align: center;
            margin-top: 30px;
            border-top: 4px solid #8B4513;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        .modal-content .modal-row .total-row label {
            color: #fff;
            margin-right: 0;
            width: auto;
        }
        .modal-content .modal-row .pay-button {
            text-align: center;
            margin-top: 35px;
        }
        .modal-content .modal-row .pay-button button {
            padding: 18px 60px;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            background: linear-gradient(90deg, #5C4033, #8B4513);
            color: #fff;
            font-size: 20px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .modal-content .modal-row .pay-button button:hover {
            background: linear-gradient(90deg, #3e2b20, #6b3a0f);
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.2);
        }
        .modal-content .vertical-divider {
            width: 4px;
            background: linear-gradient(to bottom, #5C4033, #8B4513);
            margin: 0 20px;
            border-radius: 2px;
        }

        /* Responsive cho Payment Modal */
        @media (max-width: 768px) {
            #paymentModal .modal-content {
                width: 95%;
                padding: 25px;
                border-radius: 12px;
            }
            .modal-content .modal-body {
                flex-direction: column;
                gap: 20px;
            }
            .modal-content .left-column,
            .modal-content .right-column {
                width: 100%;
                padding: 20px;
            }
            .modal-content .vertical-divider {
                display: none;
            }
            .modal-content .modal-row {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
                padding: 10px 0;
            }
            .modal-content .modal-row label {
                width: 100%;
                margin-right: 0;
                font-size: 16px;
            }
            .modal-content .modal-row input[type="text"],
            .modal-content .modal-row input[type="number"] {
                width: 100%;
                padding: 12px 10px;
                font-size: 16px;
                max-width: 100%;
                box-sizing: border-box;
                overflow: hidden;
                white-space: nowrap;
                text-overflow: ellipsis;
            }
            .modal-content .modal-row .discount-container input[type="number"],
            .modal-content .modal-row .tax-container input[type="number"] {
                width: 80px;
            }
            .modal-content .modal-row .payment-methods {
                gap: 20px;
                flex-wrap: wrap;
            }
            .modal-content .modal-row .payment-methods button,
            #paymentCashBtn,
            #paymentTransferBtn {
                padding: 12px 30px;
                font-size: 16px;
                gap: 10px;
            }
            .modal-content .modal-row .payment-methods button i {
                font-size: 20px;
            }
            .modal-content .modal-row .total-row {
                font-size: 22px;
                padding: 15px;
            }
            .modal-content .modal-row .pay-button {
                margin-top: 25px;
            }
            .modal-content .modal-row .pay-button button {
                padding: 15px 40px;
                font-size: 18px;
            }
            .modal-content h3 {
                font-size: 28px;
                padding-bottom: 12px;
            }
            .modal-content .close {
                font-size: 32px;
            }
        }
        .category-btn {
            display: block;
            width: 100%;
            padding: 16px 25px;
            margin: 0;
            border: 2px solid #ddd;
            background-color: #f9f9f9;
            text-align: left;
            font-size: 22px;
            font-weight: 500;
            color: #5C4033;
            cursor: pointer;
            border-radius: 10px;
            transition: all 0.3s ease;
        }
        .category-btn:hover {
            background-color: #f0f0f0;
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
            transform: translateY(-3px);
        }
        .category-btn.active {
            background-color: #D2B48C;
            color: #fff;
            border-color: #D2B48C;
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.2);
            transform: translateY(2px);
        }
        /* Generic Modal Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            justify-content: center;
            align-items: center;
            z-index: 10000;
        }
        .modal-content {
            background: #fff;
            padding: 20px;
            border-radius: 12px;
            max-width: 400px;
            width: 100%;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            position: relative;
            background: linear-gradient(145deg, #FFF8DC, #F5E8C7);
            border: 1px solid #D2B48C;
        }
        .modal-content h3 {
            margin: 0 0 20px;
            font-size: 24px;
            color: #5C4033;
            text-align: center;
            border-bottom: 2px solid #8B4513;
            padding-bottom: 10px;
        }
        .modal-content .close {
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 28px;
            cursor: pointer;
            color: #5C4033;
            transition: color 0.3s ease;
        }
        .modal-content .close:hover {
            color: #8B4513;
        }
        .modal-content .modal-row {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 15px;
        }
        .modal-content .modal-row label {
            font-weight: 500;
            color: #5C4033;
            width: 120px;
        }
        .modal-content .modal-row input,
        .modal-content .modal-row select {
            padding: 10px;
            border: 2px solid #D2B48C;
            border-radius: 6px;
            width: 200px;
            font-size: 16px;
            max-width: 100%;
            box-sizing: border-box;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }
        .modal-content .modal-row select[multiple] {
            height: 100px;
        }
        .modal-content .modal-row button {
            padding: 12px 25px;
            border: none;
            border-radius: 6px;
            background: linear-gradient(90deg, #5C4033, #8B4513);
            color: #fff;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .modal-content .modal-row button:hover {
            background: linear-gradient(90deg, #3e2b20, #6b3a0f);
            transform: translateY(-2px);
        }
    </style>
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

    <script type="text/javascript">
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
    </script>
</body>
</html>