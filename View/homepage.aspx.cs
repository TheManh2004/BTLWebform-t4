using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BTL.View
{
    public partial class homepage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Khởi tạo trang khi load lần đầu
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string user = username.Text.Trim();
            string pass = password.Text.Trim();

            // Kiểm tra input rỗng
            if (string.IsNullOrEmpty(user) || string.IsNullOrEmpty(pass))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "alert('Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu');", true);
                return;
            }

            // Kiểm tra thông tin đăng nhập
            if (ValidateUser(user, pass))
            {
                Session["Username"] = user;
                Response.Redirect("tongquan.aspx"); // Chuyển hướng đến trang tổng quan
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "alert('Tên đăng nhập hoặc mật khẩu không đúng');", true);
            }
        }

        // Kiểm tra thông tin đăng nhập với tài khoản cụ thể
        private bool ValidateUser(string username, string password)
        {
            // Tài khoản cụ thể: admin / MatcCoffee123
            return (username.ToLower() == "admin" && password == "12345678");
        }

        protected void lnkForgotPassword_Click(object sender, EventArgs e)
        {
            string user = username.Text.Trim();

            if (string.IsNullOrEmpty(user))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "alert('Vui lòng nhập tên đăng nhập');", true);
                return;
            }

            if (user.ToLower() == "admin")
            {
                // Giả lập gửi email
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "alert('Link khôi phục mật khẩu đã được gửi tới email của admin. Vui lòng kiểm tra hộp thư!');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    "alert('Tên đăng nhập không tồn tại');", true);
            }
        }
    }
}