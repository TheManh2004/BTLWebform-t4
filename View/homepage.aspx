<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="homepage.aspx.cs" Inherits="BTL.View.homepage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>MAT-C COFFEE Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="../Style/StyleHomePage.css" />
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
    <script src="../Scripts/ScriptsCode/HomePageJS.js">
       
    </script>
</body>
</html>