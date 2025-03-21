function forgotPassword() {
    var username = document.getElementById('<%= username.ClientID %>').value;
    if (username.trim() === "") {
        alert("Vui lòng nhập tên đăng nhập trước khi khôi phục mật khẩu");
        return false;
    }
    return confirm("Bạn muốn gửi yêu cầu khôi phục mật khẩu cho " + username + "?");
}