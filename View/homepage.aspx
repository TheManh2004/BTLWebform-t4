<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="homepage.aspx.cs" Inherits="BTL.View.homepage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>MAT-C COFFEE Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet" />
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-image: url('../data/image/homepage.jpg');
            background-repeat: no-repeat;
            background-position: center center;
            background-size: cover;
            margin: 0;
            padding: 0;
        }

        .login-container {
            max-width: 500px;
            margin: 180px auto;
            padding: 30px;
            background-color: #F5DEB3;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .login-container h2 {
            text-align: center;
            color: #5C4033;
        }

        .input {
            width: 96%;
            padding: 10px;
            margin: 10px 0;
            background-color: #F5DEB3;
            border-radius: 5px;
            font-size: 16px;
            border: 2px solid #D2B48C;
        }

        .acount label {
            color: #5C4033;
        }

        .btnLogin {
            width: 100%;
            padding: 10px;
            background-color: #8B5E3B;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

        .btnLogin:hover {
            background-color: #a65b29;
        }

        .forgot-password {
            text-align: right;
            display: block;
            font-size: 14px;
            margin-bottom: 10px;
            color: #5C4033;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <h2>MAT-C COFFEE</h2>
            <div>
                <asp:TextBox ID="username" class="input" runat="server" Placeholder="Tên đăng nhập" Required="true" />
            </div>
            <div>
                <asp:TextBox ID="password" class="input" runat="server" TextMode="Password" Placeholder="Mật khẩu" Required="true" />
            </div>
            <a href="#" class="forgot-password">Quên mật khẩu?</a>
            <asp:Button ID="btnLogin" runat="server" class="btnLogin" Text="Đăng nhập" OnClick="btnLogin_Click" />
        </div>
    </form>
    <script type="text/javascript">
        function forgotPassword() {
            var username = document.getElementById('<%= username.ClientID %>').value;
            if (username.trim() === "") {
                alert("Vui lòng nhập tên đăng nhập trước khi khôi phục mật khẩu");
                return false;
            }
            return confirm("Bạn muốn gửi yêu cầu khôi phục mật khẩu cho " + username + "?");
        }
    </script>
</body>
</html>